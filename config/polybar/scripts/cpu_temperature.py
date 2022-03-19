import subprocess
import json
import re

package_regex = re.compile(r'^Package id \d+$')
temperature_regex = re.compile(r'^temp\d+_input$')


def get_package_temperature(core_data):
    temp_input_name = \
        list(filter(temperature_regex.match, core_data.keys()))[0]
    return core_data[temp_input_name]


def print_cpu_temperature():
    sensors_json_str,  _ = subprocess.Popen(
        ['sensors -j'],
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL
    ).communicate()
    sensors = json.loads(sensors_json_str)

    coretemp = sensors['coretemp-isa-0000']
    packages = filter(package_regex.match, coretemp.keys())
    temperatures = list(map(
        lambda core: get_package_temperature(coretemp[core]),
        packages
    ))
    print(f'🌡 {sum(temperatures) / len(temperatures) :.2f}°C')


if __name__ == "__main__":
    print_cpu_temperature()
