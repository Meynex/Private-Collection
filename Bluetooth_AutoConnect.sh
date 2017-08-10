#!/usr/bin/expect -f
set address XX:XX:XX:XX:XX
set temp 1
spawn bluetoothctl -a
expect -re "#"
send "\npower off\r"
expect {
		"*succeeded*" { send "power on\r" }
		"*fail*" { send "power off\r"; send_user "\n scan off Error\n\r" }
}
sleep 3
expect "*power on*"
send "remove $address\r"
expect -re "#" { send "\nscan on\r"}
while {$temp == 1} {
sleep 15

expect "$address" { send "connect $address\r" }

expect {
		"*successful*" { send "\nscan off\r"; send "exit\r"; send_user "\nSuccessful.\r\n"; break }
		"*connect to $address*" { sleep 10 ; exp_continue }
		-re "#" {send_user "\nwaiting for connection\r" }
}
}
