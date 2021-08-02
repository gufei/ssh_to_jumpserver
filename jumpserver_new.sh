#!/usr/bin/expect

# 解决远程vim不随窗口尺寸变化的bug，具体请参考 man 7 signal
trap {
 set rows [stty rows]
 set cols [stty columns]
 stty rows $rows columns $cols < $spawn_out(slave,name)
} WINCH

curPath=$(readlink -f "$(dirname "$0")")

# 获取google code的脚本
set googlecodefile "$curPath/ga"

# 证书文件
# set pemfile "/Users/wujiaheng/.ssh/id_rsa"

# 证书文件密码 如果是自定义的密钥，有可能没有密码，空即可
set pempass ""

set secret "xxxxxxxx"

# jumpserver地址
set jumpserverhost "jumpserverhost"

# jumpserver端口
set jumpserverport 2222

# jumpserver帐号
set jumpserveruser "jump"




set google_code [$googlecodefile $secret]


#spawn ssh -i $pemfile $jumpserveruser@$jumpserverhost -p $jumpserverport
spawn ssh $jumpserveruser@$jumpserverhost -p $jumpserverport

expect {
    "Enter passphrase for key '$pemfile':" {
        send "$pempass\n"
        expect -e "\[MFA auth\]:"
        send "$google_code\n"
        expect {
            -e "\[MFA auth\]:" {
                set google_code_last [exec $googlecodefile last]
                send "$google_code_last\n"
                expect {
                    -e "\[MFA auth\]:" {
                        set google_code_next [exec $googlecodefile next]
                        send "$google_code_next\n"
                        expect {
                            -e "\[MFA auth\]:" {
                                interact
                            }
                            "Opt>" {
                                # send "p\n"
                                interact
                            }
                        }
                    }
                    "Opt>" {
                        # send "p\n"
                        interact
                    }
                }
            }
            "Opt>" {
                # send "p\n"
                interact
            }
        }
    }
    -e "\[MFA auth\]:" {
        send "$google_code\n"
        expect {
            -e "\[MFA auth\]:" {
                set google_code_last [exec $googlecodefile last]
                send "$google_code_last\n"
                expect {
                    -e "\[MFA auth\]:" {
                        set google_code_next [exec $googlecodefile next]
                        send "$google_code_next\n"
                        expect {
                            -e "\[MFA auth\]:" {
                                interact
                            }
                            "Opt>" {
                                # send "p\n"
                                interact
                            }
                        }
                    }
                    "Opt>" {
                        # send "p\n"
                        interact
                    }
                }
            }
            "Opt>" {
                # send "p\n"
                interact
            }
        }
    }

}

exit
