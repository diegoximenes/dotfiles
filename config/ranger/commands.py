import os
from ranger.api.commands import Command

################################################################################
### search commands
################################################################################

class fzf_select(Command):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import subprocess
        import os
        from ranger.ext.get_executables import get_executables

        if 'fzf' not in get_executables():
            self.fm.notify('Could not find fzf in the PATH.', bad=True)
            return

        fd = None
        if 'fdfind' in get_executables():
            fd = 'fdfind'
        elif 'fd' in get_executables():
            fd = 'fd'

        if fd is not None:
            hidden = ('--hidden' if self.fm.settings.show_hidden else '')
            exclude = "--no-ignore-vcs --exclude '.git' --exclude '*.py[co]' --exclude '__pycache__'"
            only_directories = ('--type directory' if self.quantifier else '')
            fzf_default_command = '{} --follow {} {} {} --color=always'.format(
                fd, hidden, exclude, only_directories
            )
        else:
            hidden = ('-false' if self.fm.settings.show_hidden else r"-path '*/\.*' -prune")
            exclude = r"\( -name '\.git' -o -name '*.py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
            only_directories = ('-type d' if self.quantifier else '')
            fzf_default_command = 'find -L . -mindepth 1 {} -o {} -o {} -print | cut -b3-'.format(
                hidden, exclude, only_directories
            )

        env = os.environ.copy()
        env['FZF_DEFAULT_COMMAND'] = fzf_default_command
        env['FZF_DEFAULT_OPTS'] = '--height=40% --layout=reverse --ansi --preview="{}"'.format('''
            (
                batcat --color=always {} ||
                bat --color=always {} ||
                cat {} ||
                tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {}
            ) 2>/dev/null | head -n 100
        ''')

        fzf = self.fm.execute_command('fzf --no-multi', env=env,
                                      universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)

class fzf_content_open(Command):
    """
    :fzf_content_open
    Pre-requisites: fzf, rg, bat, awk, vim or neovim
    Using `rg` to search file content recursively in current directory.
    Filtering with `fzf` and preview with `bat`.
    Pressing `Enter` on target will open at line in (neo)vim.
    """

    def execute(self):
        import subprocess
        import os
        from ranger.ext.get_executables import get_executables

        if 'rg' in get_executables():
            rg = 'rg'
        else:
            self.fm.notify("Couldn't find rg in the PATH.", bad=True)
            return

        if 'fzf' in get_executables():
            fzf = 'fzf'
        else:
            self.fm.notify("Couldn't find fzf in the PATH.", bad=True)
            return

        if 'bat' in get_executables():
            bat = 'bat'
        else:
            self.fm.notify("Couldn't find bat in the PATH.", bad=True)
            return

        editor = None
        if 'nvim' in get_executables():
            editor = 'nvim'
        elif 'vim' in get_executables():
            editor = 'vim'

        if rg is not None and fzf is not None and bat is not None and editor is not None:
            # we should not recursively search through all file content from home directory
            if (self.fm.thisdir.path == self.fm.home_path):
                self.fm.notify("Searching from home directory is not allowed", bad=True)
                return
            fzf = self.fm.execute_command(
                'rg --line-number "${1:-.}" | fzf --delimiter \':\' \
                    --preview \'bat --color=always --highlight-line {2} {1}\' \
                    | awk -F \':\' \'{print "+"$2" "$1}\'',
                universal_newlines=True,stdout=subprocess.PIPE)

            stdout, _ = fzf.communicate()
            if fzf.returncode == 0:
                if len(stdout) < 2:
                    return

                selected_line = stdout.split()[0]
                full_path = stdout.split()[1].strip()

                file_fullpath = os.path.abspath(full_path)
                file_basename = os.path.basename(full_path)

                if os.path.isdir(file_fullpath):
                    self.fm.cd(file_fullpath)
                else:
                    self.fm.select_file(file_fullpath)

                self.fm.execute_command(editor + " " + selected_line + " " + file_basename)

################################################################################
### autojump
################################################################################

import ranger.api
import subprocess
from ranger.api.commands import *

HOOK_INIT_OLD = ranger.api.hook_init


def hook_init(fm):
    def update_autojump(signal):
        subprocess.Popen(["autojump", "--add", signal.new.path])

    fm.signal_bind('cd', update_autojump)
    HOOK_INIT_OLD(fm)


ranger.api.hook_init = hook_init


class j(Command):
    """:j
    Uses autojump to set the current directory.
    """

    def execute(self):
        directory = subprocess.check_output(["autojump", self.arg(1)])
        directory = directory.decode("utf-8", "ignore")
        directory = directory.rstrip('\n')
        self.fm.execute_console("cd -r " + directory)

################################################################################
### compress and decompress commands
################################################################################

# ruff: noqa: E402
from ranger.core.loader import CommandLoader

class apack(Command):
    def execute(self):
        """ Compress marked files to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        if len(parts) == 1:
            self.fm.notify("usage: apack [flags]", bad=True)
            return
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class aunpack(Command):
    def execute(self):
        """ Extract marked files to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files or len(marked_files) > 1:
            self.fm.notify("mark a single file", bad=True)
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:] + ['-f']

        descr = "extracting files"
        obj = CommandLoader(args=['aunpack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)
