-- This is the main configuration file for Propellor, and is used to build
-- the propellor program.

import Propellor
import Propellor.CmdLine
import Propellor.Property.Scheduled
import qualified Propellor.Property.File as File
import qualified Propellor.Property.Apt as Apt
import qualified Propellor.Property.Ssh as Ssh
import qualified Propellor.Property.Network as Network
--import qualified Propellor.Property.Ssh as Ssh
import qualified Propellor.Property.Cmd as Cmd
import qualified Propellor.Property.Cron as Cron
--import qualified Propellor.Property.Sudo as Sudo
import qualified Propellor.Property.User as User
--import qualified Propellor.Property.Hostname as Hostname
--import qualified Propellor.Property.Reboot as Reboot
--import qualified Propellor.Property.Tor as Tor
import qualified Propellor.Property.Docker as Docker
import qualified Propellor.Property.Git as Git

{-
Propellor:
propellor --spin nano.quid2.org
propellor --set nano.quid2.org 'Password "quidagent@gmail.com"'
propellor --set nano.quid2.org 'SshPubKey SshRsa ""'
propellor --set nano.quid2.org 'SshPrivKey SshRsa ""'

propellor --set nano.quid2.org 'SshPubKey SshRsa "root"'
propellor --set nano.quid2.org 'SshPrivKey SshRsa "root"'
-}

main :: IO ()
main = defaultMain hosts

-- The hosts propellor knows about.
-- Edit this to configure propellor!
hosts :: [Host]
hosts =
	[{-
          nano.quid2.org: 
 * add system firewall (with propellor?)
-}
          host "nano.quid2.org" & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/h5q0pshKWDldX+vk2pFo/JdfcgrCBt73R7h/pThvyXshBGKYCB+X3dsT1ew895A9tSUIbwC7yCjXClPFfva++a7SA9D8qEWtoWuhm3KUqsGnA/5RhiyYl5WODt005xzksGUaRSTggc++0jegtDsNKADpqEY8c74ffg09C1mWGBKgJE+OCYSEpWsQ+KDpbwyyZvaUiVIDt11XfM7zwwidbgOtTO3+cohE/EkkgR47YD/OEdtcgTzemEy6Z/zdLa2uQeiCgVauSPTmJR9FKD76etaiFDTeHkLdpuCPO3NhDKR1cobRYReyatQLa3lCWdQWCUNx0AUX6vBWf7VbAX0V"
          
          {-
          & Apt.unattendedUpgrades
          & cabalUpdate          
          -- & Ssh.hostKey SshRsa
          & Ssh.keyImported SshRsa "root"
          & Apt.installed ["emacs24"]
          & quid2CheckService
          & quid2TittoService
          -}

          {-
* Add crontab jobs
        -- PROB: cannot deploy propellor?
-}
        ,host "quid2.mooo.com"
         & Apt.update & Apt.upgrade & Apt.unattendedUpgrades
         & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkjijLCHmoyOdV6EdcorFN+kB786wRKswwQ8aLSzNhg8DRyXogEXWcQ3YPFa8vBBcCiuDtagwWndBpMazPMo/BUQNjMlxRuYzxRCrYHxEkmMf2VySFUMgKKlMZDnwNGi+61GMRoKytUmkZufL/oovEaIXpQrcT3Gypj9c3d4bmA9bSYg5FNBHHnm/se4orhniBPtlaqkFoGqytSARErtpR+MJkTgS/BJ2LKwO1hi4SLuwHzddJ8axZTcCb0GFWzEuTVMfnrQvRfmCFHnnkjdHezvWu1nRvsJQeosYPIQLlv06kfbjs7rQxXVVuZwM3VFZgxPfZFXWpFsmkAymJ7Xwd"

         {-
quid2.org:
 * periodically copy full copy of backup (maybe with obnam?)
 * add system firewall
 * fix quid2 and REBOOT
-}
        ,host "quid2.org"
         & alias "backup.quid2.org"
         & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYlRxBBfWKQWtemEORJLeP6InDRS9x7PvrEaPTCFW/uyneMhs7Ug9xDt/xdq9AIJeGlQxmAAHabIRvoTzAmgI4/c9PXB337BkpF4oPt7tpGJZN3FfyeOM33ShnFyIG0HswwXj8XSQ5K8DGQiClg7wP06ez3jyW+4z0FaXFrD3PKF0ANhjfPjq9wWJi/xZs4sEV4SPnlUNGn2ofAKkDBepdc9igvIZb/TY1UIhZouiPCHICnM6x/UgPuyx+v0zIrpJJs0Hosu2f6Te9rwjdYGPccQRmUG7LXKJXPSyxu9txQT7frwm1PA+NVb8KR4qsH51qqufzshqOyBk3+51KlL1v"  
          
        -- quid2.org service  
        ,host "[quid2.org]:2222" & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR89KzcSBEJQ38/1gKIt/sqa4L71RzwoPS24qKyv5SmSJuWMpbPpoGIep6ucUYXFAtaLKwHxVXHfWrE4szZtYP+qVb9sVdPhhQ1GQThJFBHKJzSkk7jmO3tZ0gwl25GYebvTWoj+MszpdBxtofhHqiYmPFTSN/wlVGU1UmpZI6uUAUu+DA+1/uOHFCwCniQoLloiVDOGudKUAwaTubGc/qjVxQIfOACbbDN7CkbVA8NuKwqbfEZta3jafwk3HgIyQmDBU7gMYLWS0Z5GX4HsNEsogMsxNslNrG+EWwOgs1myVF2Uplw5h+1gnErREocWDrQ6jMAJRNp5QT4qO0bouX"
	]

quid2TittoService = background "quid2-titto" `requires` quid2TittoPkg

background name = userScriptProperty "root" [unwords ["killall -s SIGKILL",name]
                                            ,unwords ["/root/.cabal/bin/"++name,"> /dev/null 2>&1 &"]
                                            ]

service name = userScriptProperty "root" [concat ["/root/.cabal/bin/",name," stop"],concat ["/root/.cabal/bin/",name," start"]]
               `requires` User.accountFor name

quid2TittoPkg = deployMyPackage "quid2-titto"
              `requires` Apt.installed ["git"]
              `requires` quidUtilPkg

quid2CheckService = combineProperties "cronned quid2-check"
                    [Cron.job "quid2-check" "*/15 * * * *" "root" "/root" "/root/.cabal/bin/quid2-check check"
                    ,Cron.job "quid2-check2" "00 15 * * *" "root" "/root" "/root/.cabal/bin/quid2-check check andReport"
                    ,Cron.job "quid2-check3" "*/30 * * * *" "root" "/root" "/root/.cabal/bin/quid2-check /root/backup"
                    ]
                    `requires` 
                    (deployMyPackage "quid2-check"
                     `requires` Apt.installed ["nmap","mailutils"]
                     `requires` Ssh.knownHost hosts "[quid2.org]:2222" "root"
                     `requires` quidUtilPkg)          
             
quidUtilPkg = deployMyPackage "quid2-util"
              `requires` Apt.installed ["zlib1g-dev"]
              `requires` deployMyPackage "propellor" 

cabalUpdate = userScriptProperty "root" ["cabal update"]

deployMyPackage :: String -> Property
deployMyPackage repo = rebuildMyRepo repo `requires` cloneMyRepo repo

rebuildMyRepo :: String -> Property
rebuildMyRepo repo = userScriptProperty "root"
                     ["cd /root/repo/" ++ repo
                     ,"cabal install --verbose=1 --disable-documentation --force-reinstalls --reinstall"
                     ]

cloneMyRepo :: String -> Property
cloneMyRepo repo = Git.cloned "root" ("https://github.com/tittoassini/" ++ repo) ("/root/repo/"++repo) Nothing