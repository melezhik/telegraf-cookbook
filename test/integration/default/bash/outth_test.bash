# here we go!
PATH=$PATH:/usr/local/bin/:/opt/telegraf
sparrow 1>/dev/null || exit 1
sparrow project create foo
sparrow check add foo tele
sparrow check set foo tele outth-telegraf
sparrow check show foo tele 
match_l=1000 sparrow check run foo tele

