#!/usr/bin/env python3

import time
import json, os, urllib
import configparser
import subprocess,base64

from sub_update import update
from sub_merge import merge
from subconverter import convert, base64_decode

config_file = 'config.ini'

def configparse(section):
    config = configparser.ConfigParser()
    config.read(config_file, encoding='utf-8')
    if section == 'common':
        return config['common']
    elif section == 'subconverter':
        return config['subconverter']
    elif section == 'speedtest':
        return config['speedtest']

if __name__ == '__main__':
    if configparse('common').getboolean('update_enabled'):
        config = configparse('common')
        update(config)

    if configparse('common').getboolean('merge_enabled'):
        file_dir = configparse('common')
        format_config = configparse('subconverter')
        merge(file_dir, format_config)

    if configparse('common').getboolean('speedtest_enabled'):
        share_file_subconvert = configparse('common')['share_file_subconvert']
        share_file_mihomo = configparse('common')['share_file_mihomo']
        subscription = configparse('speedtest')['subscription']
        range = configparse('speedtest')['output_range']
        os.system(f'python3 litespeedtest/speedtest.py --subscription \"{subscription}\" --range \"{range}\" --path \"../temp\"')
        east_asian_proxies = convert('../temp','base64',{'deduplicate':False,'include':'港|HK|Hong Kong|坡|SG|狮城|Singapore|日|JP|东京|大阪|埼玉|Japan|台|TW|新北|彰化|Taiwan|韩|KR|KOR|首尔|Korea'})
        north_america_proxies = convert('../temp','base64',{'deduplicate':False,'include':'美|US|United States|加拿大|CA|Canada|波特兰|达拉斯|俄勒冈|凤凰城|费利蒙|硅谷|拉斯维加斯|洛杉矶|圣何塞|圣克拉拉|西雅图|芝加哥'})
        other_country_proxies = convert('../temp','base64',{'deduplicate':False,'include':'','exclude':'US|HK|SG|JP|TW|KR|美|港|坡|日|台|韩|CA|加'})
        area_proxies = {
            'east_asia': [east_asian_proxies, -1],
            'north_america': [north_america_proxies, -1],
            'other_area':[other_country_proxies, -1]
        }
        share_proxies = []
        for area in area_proxies.keys():
            with open('./temp', 'w', encoding='utf-8') as temp_file:
                temp_file.write(area_proxies[area][0])
            os.system(f'python3 litespeedtest/speedtest.py --subscription \"../temp\" --range \"{area_proxies[area][1]}\" --path \"../temp\"')
            with open('./temp', 'r', encoding='utf-8') as temp_file:
                content = temp_file.read()
                share_proxies.append(base64_decode(content))
        with open('./temp', 'w', encoding='utf-8') as temp_file:
            temp_file.write(''.join(share_proxies))
        os.system(f'python3 subconverter/subconvert.py --subscription \"../temp\" --target \"base64\" --output \"{share_file_subconvert}\"')
        os.system(f'python3 subconverter/subconvert.py --subscription \"../temp\" --target \"clash\" --output \"{share_file_mihomo}\"')
        os.remove('./temp')
