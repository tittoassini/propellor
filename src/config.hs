{-# LANGUAGE TemplateHaskell #-}
-- This is the main configuration file for Propellor, and is used to build
-- the propellor program.
module Main where

import Propellor
import Propellor.CmdLine
-- import Propellor.Property.Scheduled
import qualified Propellor.Property.File as File
import qualified Propellor.Property.Apt as Apt
import qualified Propellor.Property.Ssh as Ssh
-- import qualified Propellor.Property.Network as Network
--import qualified Propellor.Property.Ssh as Ssh
-- import qualified Propellor.Property.Cmd as Cmd
import qualified Propellor.Property.Cron as Cron
--import qualified Propellor.Property.Sudo as Sudo
import qualified Propellor.Property.User as User
--import qualified Propellor.Property.Hostname as Hostname
--import qualified Propellor.Property.Reboot as Reboot
--import qualified Propellor.Property.Tor as Tor
-- import qualified Propellor.Property.Docker as Docker
import qualified Propellor.Property.Git as Git
-- -- import qualified Propellor.Property.Reboot as Reboot
import Utility.FileMode

{-
Backup to nano from server1:
rsync -avzH --progress --delete --delete-excluded  /root/data root@nano.quid2.org:/root

rsync -avzHn --progress --delete --delete-excluded  /root/attic/docker root@nano.quid2.org:/root/attic

And back:
rsync -avzHn --progress --delete --delete-excluded  /root/data root@188.165.202.170:/root

rsync -avzH --progress --delete --delete-excluded  /root/data root@188.165.202.170:/root  > /dev/null 2>&1 &

Run Propellor:

cd ~/.propellor;./propellor --spin nano.quid2.org

Add secret properties to server's privdata
propellor --set nano.quid2.org 'Password "quidagent@gmail.com"'
propellor --set nano.quid2.org 'SshPubKey SshRsa ""'
propellor --set nano.quid2.org 'SshPrivKey SshRsa ""'

propellor --set nano.quid2.org 'SshPubKey SshRsa "root"'
propellor --set nano.quid2.org 'SshPrivKey SshRsa "root"'

propellor --set nano.quid2.org 'SshAuthorizedKeys "root"'


---------- New Server
-- Add titto's public key to
propellor --set 188.165.202.170 'SshAuthorizedKeys "titto"'

propellor --set 188.165.202.170 'SshPubKey SshRsa "root"'
propellor --set 188.165.202.170 'SshPrivKey SshRsa "root"'

propellor --set 188.165.202.170 'SshAuthorizedKeys "root"'

propellor --set quid.org 'Password "attic"'

-- Apply changes
cd ~/.propellor;./propellor --spin 188.165.202.170

cd ~/.propellor;./propellor --spin nano.quid2.org
cd ~/.propellor;./propellor --spin quid2.org
-}

-- * update to latest propellor when it works
-- * mac: check local open services
main :: IO ()
main = defaultMain hosts

p1 = do
  mapM_ putStrLn [nanoPub,tittoPub,""]

-- ssh-keygen -t rsa -b 2048

tittoPub = "ssh-dss AAAAB3NzaC1kc3MAAACBALwa1J9HDpcRkMpliV3QnYPN5GDuasBdM1s+RpZ3v82PYyOxqVn+Vt79VYuyTc7TK8KnvsNDVnfFETHy3IxY772YRR8X+T2Wt1tcFBednPf5bIPafX1DhKPXTywG8Q4xriidzHZLlj3eyXWeCElxNk4c4d+NIWK7M3iJDCOphQeFAAAAFQCPaYqOr09/d/2taJmWlZvTP7xYEwAAAIBbyd/CjHf8zw0W1dNsZO0VXwieAPa/tAkCAxeWCsDxSyfeasXDtciJZEPAq6U4H67b3lHwU0afJw1NycfirP0hYsT2Icwg1KXhCD6zDaeswWidhLPII8Cz5vqfXDobIZF17bODh1WHUtuwLxwA4z6FiBU8EMkeDdm28R5fe0QemAAAAIB2dI4oruRoPpxJmC3ETVdT3zBp73eGr9nL8IU4i+uOuJGtb1nOCcJYQxSw/1qnEGIN/PBlR4tufV6KiBCPXcrl1GhhQ9oVUJBZyZrM29HDe9VZ3WCZ6usmNRnTEnq593O0189dv4XRZQkSts5f/hdRg/kToyqaG+egBerA9AfsrA== titto@ubuntu"

nanoPub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/h5q0pshKWDldX+vk2pFo/JdfcgrCBt73R7h/pThvyXshBGKYCB+X3dsT1ew895A9tSUIbwC7yCjXClPFfva++a7SA9D8qEWtoWuhm3KUqsGnA/5RhiyYl5WODt005xzksGUaRSTggc++0jegtDsNKADpqEY8c74ffg09C1mWGBKgJE+OCYSEpWsQ+KDpbwyyZvaUiVIDt11XfM7zwwidbgOtTO3+cohE/EkkgR47YD/OEdtcgTzemEy6Z/zdLa2uQeiCgVauSPTmJR9FKD76etaiFDTeHkLdpuCPO3NhDKR1cobRYReyatQLa3lCWdQWCUNx0AUX6vBWf7VbAX0V"

sys1Pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDE7UqCma1PPUxYKTqqxiLyJ1zYQUdX8qPq/dMubWNhrnCraf98rNV5BHNKqFcISIGai+KJV7din/SsHWqsfn4iAKdaFXkHtwiIIVeHms3ZGlEtFcrt9Vr+ru0/T7fmyiOi3GlB68ceF2yo49a/LRw1PXpx39mcXhytK+CnOF9KwrVq3KH+i/cZdjgb8PpO7jdkXOTdJZur3pTtujc/l/GdYM8t9ohMt5YCkzUaiMOvuG/zOeMlFdiEsqV3JqTV4Slb1d4ukJyL70yGEeYfZ0v208uSe4o3LVeB0UlzXkHwOjVClRwk0cgVbQMPE/FKwhj1CSSQ12zwbCTAJWnAvdAV root@ns310652.ip-188-165-202.eu"

raspPub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkjijLCHmoyOdV6EdcorFN+kB786wRKswwQ8aLSzNhg8DRyXogEXWcQ3YPFa8vBBcCiuDtagwWndBpMazPMo/BUQNjMlxRuYzxRCrYHxEkmMf2VySFUMgKKlMZDnwNGi+61GMRoKytUmkZufL/oovEaIXpQrcT3Gypj9c3d4bmA9bSYg5FNBHHnm/se4orhniBPtlaqkFoGqytSARErtpR+MJkTgS/BJ2LKwO1hi4SLuwHzddJ8axZTcCb0GFWzEuTVMfnrQvRfmCFHnnkjdHezvWu1nRvsJQeosYPIQLlv06kfbjs7rQxXVVuZwM3VFZgxPfZFXWpFsmkAymJ7Xwd"

-- The hosts propellor knows about.
-- Edit this to configure propellor!
hosts :: [Host]
hosts =
	[{-
 * add system firewall (with propellor?)
-}
          host "nano.quid2.org"
          & sshPubKey nanoPub
          -- Manual additions
          -- cron jobs go to /etc/cron.d/
          -- & Cron.job "titto-to-attic" "30 * * * *" "root" "/root/data/titto" "attic create -vs /root/attic/titto:: ."
          {-
          & Ssh.authorizedKeys "root"
          & Ssh.keyImported SshRsa "root" -- Setup ssh key for 'root' user
          & Apt.unattendedUpgrades
          & Apt.installed ["emacs24"]
          & cabalUpdate
          & quid2CheckService
          & quid2TittoService -- BUG: fails to start unless is already running
          -}

          -- Initial setup
          -- Problem with debian 8, cannot access github unless
          -- apt-get install ca-certificates
          ,host "quid2.org" --           ,host "188.165.202.170"
          & quid2Frequent -- & quid2Hourly & quid2Daily
          -- & atticInstalled -- & dockerInstalled & ftpSpace &&
          {- onceOnly
          & sshPubKey sys1Pub
          & Ssh.authorizedKeys "root"
          & Ssh.keyImported SshRsa "root"
          & Ssh.knownHost hosts "nano.quid2.org" "root"
          & Apt.installed ["emacs24","xz-utils","curl","phoronix-test-suite"]
          -}
          {- Later
          & failOvers ["46.105.240.20","46.105.240.21","46.105.240.22","46.105.240.23"]
          & Apt.update & Apt.upgrade

                 -- & Ssh.passwordAuthentication False
                 -- & Reboot.now
                 -- & Apt.unattendedUpgrades

                 --  /root/.netrc /root/bin
                 -- & Cron.job "backup" "*/15 * * * *" "root" "/root" "/root/bin/backup" -- rsync -avzH --progress --delete /root/data root@nano.quid2.org:/root/backup/sys1"

          -}
                 -- 'quid2' docker service
                 ,host "[quid2.org]:2222" & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR89KzcSBEJQ38/1gKIt/sqa4L71RzwoPS24qKyv5SmSJuWMpbPpoGIep6ucUYXFAtaLKwHxVXHfWrE4szZtYP+qVb9sVdPhhQ1GQThJFBHKJzSkk7jmO3tZ0gwl25GYebvTWoj+MszpdBxtofhHqiYmPFTSN/wlVGU1UmpZI6uUAUu+DA+1/uOHFCwCniQoLloiVDOGudKUAwaTubGc/qjVxQIfOACbbDN7CkbVA8NuKwqbfEZta3jafwk3HgIyQmDBU7gMYLWS0Z5GX4HsNEsogMsxNslNrG+EWwOgs1myVF2Uplw5h+1gnErREocWDrQ6jMAJRNp5QT4qO0bouX"

                 -- 'dev' docker service
                 ,host "[quid2.org]:3000" & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1OPNMhPyVdSUcwP47qxtjn+ZXlT2de6vXNeRVVP1fTbyh/DBkoH1zUTM5RdStPSRtYXjP0C+eN/xAAOHaYXIoIYyjLR5ZLqOOgyqQ6ghv5Rs7vQJ6FqyFBLcKXdeBhjVcTnwGKejK+cM7MicWzINJkpdh4/AEuv4zlc8QS1wH9lMTYV2H/BhyMx1YV4DzDgpTmEfJIecOnS0r0U2VjjA4HNGxnjvx5X9J+l9vluo2uu5XeuPY9jC5zW7nPjwtTYsHwpsx14BudDYIcgcph7bjvqvSnA1YwgU5A3NefifCrA+kVpd/9kWAx+CnezFk4P1JaBvEd6eUAhMjl9OpZXXh"

{-
* deploy propellor: PROB: Unable to locate package libghc-async-dev
* Add crontab jobs
 # freedns update
*/30 * * * * /usr/bin/wget -qO- --no-check-certificate https://freedns.afraid.org/dynamic/update.php?VVZITkJhMzFVMVVBQUttUFNRUUFBQUFJOjkyNzkyMTk=
*/20 * * * * /usr/local/bin/quid2-check /root/backup
-}
          ,host "quid2.mooo.com"
           & Apt.update & Apt.upgrade & Apt.unattendedUpgrades
           & sshPubKey raspPub
	]

f = mapM_ putStrLn $ failOvers_ ["46.105.240.20","46.105.240.21"]

failOvers = File.containsLines "/etc/network/interfaces" . failOvers_

failOvers_ = concatMap fo . zip [0..]
  where fo (n,ip) = let i = "eth0:"++show n
                    in [""
                       ,u ["auto",i]
                       ,u ["iface",i,"inet static"]
                       ,u ["    address",ip]
                       ,   "    netmask 255.255.255.255"
                           -- broadcast failoverIP?
                       ,""
                       ,"iface eth0 inet static"
                       ,u ["    post-up /sbin/ifconfig",i,ip,"netmask 255.255.255.255 broadcast",ip]
                       ,u ["    pre-down /sbin/ifconfig",i,"down"]
                       ]

        u = unwords

-- untested
unisonInstalled = let v = "2.48.3" in userScriptProperty "root" ["cd /tmp"
                                                                ,concat ["wget http://www.seas.upenn.edu/~bcpierce/unison/download/releases/stable/unison-",v,".tar.gz"]
                                                                ,"tar xvzf unison-",v,".tar.gz"
                                                                ,concat ["cd unison-",v]
                                                                ,"make UISTYLE=text"
                                                                ,"mv ./unison /usr/bin/"] `requires` Apt.installed ["ocaml"]
-- untested
-- PROB: on Debian, docker has to be started manually with 'service docker start'
-- with kernel >= 3.18 add DOCKER_OPTS="-s overlay" @ /etc/default/docker
dockerInstalled  = userScriptProperty "root" ["curl -sSL https://get.docker.com/ | sh"]

-- untested
atticInstalled  = userScriptProperty "root" ["pip3 install attic --upgrade"] `requires` Apt.installed ["build-essential","python3-pip","libssl-dev","libevent-dev","uuid-dev","libacl1-dev","liblzo2-dev"]

-- untested
quid2Frequent = rootCron "frequent" (EveryMins 15)  ["rsync -avzH --progress --delete /root/data root@nano.quid2.org:/root/backup/sys1"]

quid2Hourly = rootCron "hourly" (HourlyAt 0) [
  "# attic sys1"
  ,"cd /root/data"

  ,"attic create -s /root/attic/quid2::`date +%Y-%m-%d-%H-%M` quid2-store quid2-user"

  ,"# attic docker"
  ,"cd /root/data/docker"
  ,"attic create -s /root/attic/docker::`date +%Y-%m-%d-%H-%M` ."
  ,"attic prune  -v /root/attic/docker --keep-within=10d --keep-weekly=4 --keep-monthly=-1"
  ,"attic list /root/attic/docker"
  ]

quid2Daily = rootCron "daily" (DailyAt 4) [
  "# --------- push attic/sys1 attic/docker to nano ----------"
  ,"rsync -avzH --progress --delete /root/attic/docker /root/attic/sys1 root@nano.quid2.org:/root/attic"

  ,"# --------- pull attic from nano ----------"
  --,"rsync -avzH --progress --delete root@nano.quid2.org:/root/attic/Music root@nano.quid2.org:/root/attic/titto /root/attic"
  ,"rsync -avzHn --progress --delete --exclude /root/attic/docker/** --exclude /root/attic/sys1/** root@nano.quid2.org:/root/attic /root"

  ,"# save attic in ftp backup server"
  ,"lftp ftp://ns310652.ip-188-165-202.eu@ftpback-rbx3-272.mybackup.ovh.net -e \"mirror --reverse --delete --verbose /root/attic;quit\""
  ]

data Freq = EveryMins Int | HourlyAt Int | DailyAt Int

cronTime (EveryMins m) = concat ["*/",show m," * * * *"]
cronTime  (HourlyAt m) = concat [show m," * * * *"]
cronTime  (DailyAt h) = concat ["0 ",show h," * * *"]
rootCron name t ls = (property ("cronFile " ++ fp) $ withPrivData (Password "attic") $ ensureProperty . fl)
                     `requires` Cron.job ("root-"++ name) (cronTime t) "root" "/root" fp
  where
        fp = "/root/bin/" ++ name
        fl pwd = combineProperties "" [fp `File.hasContent` (concat ["export ATTIC_PASSPHRASE=","pwd"]:ls),fp `File.mode` 0o700]

-- untested
ftpSpace :: Property
ftpSpace = property "ftp space ready to use" $
           withPrivData (Password "ftp") $ \pwd -> ensureProperty ("/root/.netrc" `File.hasContent` ["machine ftpback-rbx3-272.mybackup.ovh.net login ns310652.ip-188-165-202.eu password " ++ pwd]`requires` Apt.installed ["lftp"])

quid2TittoService = background "quid2-titto" `requires` quid2TittoPkg

background name = userScriptProperty "root" [unwords ["killall -s SIGKILL",name]
                                            ,unwords ["/root/.cabal/bin/"++name,"> /dev/null 2>&1 & "]
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


{- speed test
pip3 install speedtest-cli
speedtest
-}

{-
-- Update kernel (FAIL, ALSO NEED TO SETUP GRUB BEFORE REBOOTING)
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18.7-vivid/linux-headers-3.18.7-031807_3.18.7-031807.201502110759_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18.7-vivid/linux-headers-3.18.7-031807-generic_3.18.7-031807.201502110759_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18.7-vivid/linux-image-3.18.7-031807-generic_3.18.7-031807.201502110759_amd64.deb

wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18.7-vivid/linux-headers-3.18.7-031807-generic_3.18.7-031807.201502110759_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18.7-vivid/linux-headers-3.18.7-031807_3.18.7-031807.201502110759_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18.7-vivid/linux-image-3.18.7-031807-generic_3.18.7-031807.201502110759_amd64.deb

-- setup grub
fgrep menuentry /boot/grub/grub.cfg
..
$ vim /etc/default/grub
[... add the following line at the bottom of the file ...]
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 3.13.0-39-generic"
$ reboot now
see http://blog.adimian.com/2014/10/enable-aufs-support-for-docker-on-soyoustart-ovh/
-}
