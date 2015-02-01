-- This is the main configuration file for Propellor, and is used to build
-- the propellor program.

import Propellor
import Propellor.CmdLine
-- import Propellor.Property.Scheduled
-- import qualified Propellor.Property.File as File
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

{-
Run Propellor:

cd ~/.propellor;./propellor --spin nano.quid2.org

Add secret properties to server's privdata
propellor --set nano.quid2.org 'Password "quidagent@gmail.com"'
propellor --set nano.quid2.org 'SshPubKey SshRsa ""'
propellor --set nano.quid2.org 'SshPrivKey SshRsa ""'

propellor --set nano.quid2.org 'SshPubKey SshRsa "root"'
propellor --set nano.quid2.org 'SshPrivKey SshRsa "root"'

---------- New Server
-- Add titto's public key to 
propellor --set 188.165.202.170 'SshAuthorizedKeys "root"'

ssh-dss AAAAB3NzaC1kc3MAAACBALwa1J9HDpcRkMpliV3QnYPN5GDuasBdM1s+RpZ3v82PYyOxqVn+Vt79VYuyTc7TK8KnvsNDVnfFETHy3IxY772YRR8X+T2Wt1tcFBednPf5bIPafX1DhKPXTywG8Q4xriidzHZLlj3eyXWeCElxNk4c4d+NIWK7M3iJDCOphQeFAAAAFQCPaYqOr09/d/2taJmWlZvTP7xYEwAAAIBbyd/CjHf8zw0W1dNsZO0VXwieAPa/tAkCAxeWCsDxSyfeasXDtciJZEPAq6U4H67b3lHwU0afJw1NycfirP0hYsT2Icwg1KXhCD6zDaeswWidhLPII8Cz5vqfXDobIZF17bODh1WHUtuwLxwA4z6FiBU8EMkeDdm28R5fe0QemAAAAIB2dI4oruRoPpxJmC3ETVdT3zBp73eGr9nL8IU4i+uOuJGtb1nOCcJYQxSw/1qnEGIN/PBlR4tufV6KiBCPXcrl1GhhQ9oVUJBZyZrM29HDe9VZ3WCZ6usmNRnTEnq593O0189dv4XRZQkSts5f/hdRg/kToyqaG+egBerA9A
fsrA== titto@ubuntu

-- Apply changes
cd ~/.propellor;./propellor --spin 188.165.202.170

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYlRxBBfWKQWtemEORJLeP6InDRS9x7PvrEaPTCFW/uyneMhs7Ug9xDt/xdq9AIJeGlQxmAAHabIRvoTzAmgI4/c9PXB337BkpF4oPt7tpGJZN3FfyeOM33ShnFyIG0HswwXj8XSQ5K8DGQiClg7wP06ez3jyW+4z0FaXFrD3PKF0ANhjfPjq9wWJi/xZs4sEV4SPnlUNGn2ofAKkDBepdc9igvIZb/TY1UIhZouiPCHICnM6x/UgPuyx+v0zIrpJJs0Hosu2f6Te9rwjdYGPccQRmUG7LXKJXPSyxu9txQT7frwm1PA+NVb8KR4qsH51qqufzshqOyBk3+51KlL1v
ssh-dss AAAAB3NzaC1kc3MAAACBAOeVvbO508J4MKyixDHYjxlBsuMhRZL2cEMB1a3okXtMJCjh3Rml4EgKzG6gRLV9mNtA0eyN0GYbwXk6omCKeL+YA2vKrm6Ba4dmhLrdf97y6r6xxj6Gp0FRcmGbOT3TJBm36Z1RKPZermYsVrP/xaz9IVO/gluMPeKtj10UMS2rAAAAFQCaqFbe+CmgSlNjUgEcy0t0SyOkmQAAAIEAzd+lg6TPPU+0I8pLI7tdDZSA7Otp3T1UdRd4oMK1kJSBVAYDaTsEZ/WLTyzHFZyafI8fL1fLsrj5qJkuph5rnxBaYxfwF2MQzjEVOkob/lS0puUVcfceZ8qKbZ8hd6JYms2CmOCmWQ/wtUzzEWMqxf9WcY4MnJQ+ZWpKaR+AWtEAAACAFsQM8hqf4NrBkjW2DAGfPHNNPC3Dgzb4vxYwgsw85ai59yTCBnVPtUFWDYmLI+PJhaAcrJlNY1tSzJkEyeDlhMQXH4+/wsdv7PknaStMrjb4z3B7N/dED4rioROsW2l0Wg2MuxQdbH5m9Y/3HGBuGIg6/UECCH6U6OqvMUpcujI= root@ns3296048.ip-5-135-189.eu
-}

-- * update to latest propellor when it works
-- * mac: check local open services
main :: IO ()
main = defaultMain hosts

-- The hosts propellor knows about.
-- Edit this to configure propellor!
hosts :: [Host]
hosts =
	[{-
 * add system firewall (with propellor?)
-}
          host "nano.quid2.org"
          & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/h5q0pshKWDldX+vk2pFo/JdfcgrCBt73R7h/pThvyXshBGKYCB+X3dsT1ew895A9tSUIbwC7yCjXClPFfva++a7SA9D8qEWtoWuhm3KUqsGnA/5RhiyYl5WODt005xzksGUaRSTggc++0jegtDsNKADpqEY8c74ffg09C1mWGBKgJE+OCYSEpWsQ+KDpbwyyZvaUiVIDt11XfM7zwwidbgOtTO3+cohE/EkkgR47YD/OEdtcgTzemEy6Z/zdLa2uQeiCgVauSPTmJR9FKD76etaiFDTeHkLdpuCPO3NhDKR1cobRYReyatQLa3lCWdQWCUNx0AUX6vBWf7VbAX0V"

          & Ssh.authorizedKeys "root" & Ssh.keyImported SshRsa "root"
          & Apt.unattendedUpgrades
          & Apt.installed ["emacs24"]
          & cabalUpdate          
          & quid2CheckService
          & quid2TittoService -- BUG: fails to start unless is already running


          -- Initial setup
          ,host "188.165.202.170"
          -- & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/h5q0pshKWDldX+vk2pFo/JdfcgrCBt73R7h/pThvyXshBGKYCB+X3dsT1ew895A9tSUIbwC7yCjXClPFfva++a7SA9D8qEWtoWuhm3KUqsGnA/5RhiyYl5WODt005xzksGUaRSTggc++0jegtDsNKADpqEY8c74ffg09C1mWGBKgJE+OCYSEpWsQ+KDpbwyyZvaUiVIDt11XfM7zwwidbgOtTO3+cohE/EkkgR47YD/OEdtcgTzemEy6Z/zdLa2uQeiCgVauSPTmJR9FKD76etaiFDTeHkLdpuCPO3NhDKR1cobRYReyatQLa3lCWdQWCUNx0AUX6vBWf7VbAX0V"
          -- Authorize access from titto
          & Ssh.authorizedKeys "root"
          -- Setup ssh key for 'root' user 
          -- & Ssh.keyImported SshRsa "root"
          & Ssh.passwordAuthentication False
          & Apt.unattendedUpgrades
          & Apt.installed ["emacs24"]      
          -- & cabalUpdate          
          -- & quid2CheckService
          -- & quid2TittoService -- BUG: fails to start unless is already running

          
          {-
* deploy propellor: PROB: Unable to locate package libghc-async-dev
* Add crontab jobs
# freedns update
*/30 * * * * /usr/bin/wget -qO- --no-check-certificate https://freedns.afraid.org/dynamic/update.php?VVZITkJhMzFVMVVBQUttUFNRUUFBQUFJOjkyNzkyMTk=
*/20 * * * * /usr/local/bin/quid2-check /root/backup
-}
        ,host "quid2.mooo.com"
         & Apt.update & Apt.upgrade & Apt.unattendedUpgrades
         & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkjijLCHmoyOdV6EdcorFN+kB786wRKswwQ8aLSzNhg8DRyXogEXWcQ3YPFa8vBBcCiuDtagwWndBpMazPMo/BUQNjMlxRuYzxRCrYHxEkmMf2VySFUMgKKlMZDnwNGi+61GMRoKytUmkZufL/oovEaIXpQrcT3Gypj9c3d4bmA9bSYg5FNBHHnm/se4orhniBPtlaqkFoGqytSARErtpR+MJkTgS/BJ2LKwO1hi4SLuwHzddJ8axZTcCb0GFWzEuTVMfnrQvRfmCFHnnkjdHezvWu1nRvsJQeosYPIQLlv06kfbjs7rQxXVVuZwM3VFZgxPfZFXWpFsmkAymJ7Xwd"

         {-
 * periodically copy full copy of backup with obnam
 * add system firewall
 * backup/stop quid2 and REBOOT
-}
        ,host "quid2.org"
         & alias "backup.quid2.org"
         & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYlRxBBfWKQWtemEORJLeP6InDRS9x7PvrEaPTCFW/uyneMhs7Ug9xDt/xdq9AIJeGlQxmAAHabIRvoTzAmgI4/c9PXB337BkpF4oPt7tpGJZN3FfyeOM33ShnFyIG0HswwXj8XSQ5K8DGQiClg7wP06ez3jyW+4z0FaXFrD3PKF0ANhjfPjq9wWJi/xZs4sEV4SPnlUNGn2ofAKkDBepdc9igvIZb/TY1UIhZouiPCHICnM6x/UgPuyx+v0zIrpJJs0Hosu2f6Te9rwjdYGPccQRmUG7LXKJXPSyxu9txQT7frwm1PA+NVb8KR4qsH51qqufzshqOyBk3+51KlL1v"
         & Ssh.knownHost hosts "nano.quid2.org" "root"
         -- make second backup copy 
         & Cron.job "rsync-backup" "*/30 * * * *" "root" "/root"
         "rsync -avz --progress --delete /home/backup root@nano.quid2.org:/home"

         {-
         & Obnam.backup "/home/backup" "*/20 * * * *"
		[ "--repository=sftp://nano.quid2.org/~/mygitrepos.obnam"
	, "--encrypt-with=1B169BE1"
		] Obnam.OnlyClient
		`requires` Gpg.keyImported "1B169BE1" "root"
		`requires` Ssh.keyImported SshRsa "root"
          -}
         
        -- 'quid2' docker service  
        ,host "[quid2.org]:2222" & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR89KzcSBEJQ38/1gKIt/sqa4L71RzwoPS24qKyv5SmSJuWMpbPpoGIep6ucUYXFAtaLKwHxVXHfWrE4szZtYP+qVb9sVdPhhQ1GQThJFBHKJzSkk7jmO3tZ0gwl25GYebvTWoj+MszpdBxtofhHqiYmPFTSN/wlVGU1UmpZI6uUAUu+DA+1/uOHFCwCniQoLloiVDOGudKUAwaTubGc/qjVxQIfOACbbDN7CkbVA8NuKwqbfEZta3jafwk3HgIyQmDBU7gMYLWS0Z5GX4HsNEsogMsxNslNrG+EWwOgs1myVF2Uplw5h+1gnErREocWDrQ6jMAJRNp5QT4qO0bouX"

         -- 'dev' docker service  
        ,host "[quid2.org]:3000" & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1OPNMhPyVdSUcwP47qxtjn+ZXlT2de6vXNeRVVP1fTbyh/DBkoH1zUTM5RdStPSRtYXjP0C+eN/xAAOHaYXIoIYyjLR5ZLqOOgyqQ6ghv5Rs7vQJ6FqyFBLcKXdeBhjVcTnwGKejK+cM7MicWzINJkpdh4/AEuv4zlc8QS1wH9lMTYV2H/BhyMx1YV4DzDgpTmEfJIecOnS0r0U2VjjA4HNGxnjvx5X9J+l9vluo2uu5XeuPY9jC5zW7nPjwtTYsHwpsx14BudDYIcgcph7bjvqvSnA1YwgU5A3NefifCrA+kVpd/9kWAx+CnezFk4P1JaBvEd6eUAhMjl9OpZXXh"
	]

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
