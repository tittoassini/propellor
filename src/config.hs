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
	[ host "nano.quid2.org"
          {-
          & Apt.unattendedUpgrades
          & cabalUpdate          
          & Ssh.hostKey SshRsa
          & Ssh.keyImported SshRsa "root"
          & quid2CheckService
          -}
          
          & quid2TittoPkg
          & service "quid2-titto" 

        -- quid2.org service  
        ,host "[quid2.org]:2222" & sshPubKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR89KzcSBEJQ38/1gKIt/sqa4L71RzwoPS24qKyv5SmSJuWMpbPpoGIep6ucUYXFAtaLKwHxVXHfWrE4szZtYP+qVb9sVdPhhQ1GQThJFBHKJzSkk7jmO3tZ0gwl25GYebvTWoj+MszpdBxtofhHqiYmPFTSN/wlVGU1UmpZI6uUAUu+DA+1/uOHFCwCniQoLloiVDOGudKUAwaTubGc/qjVxQIfOACbbDN7CkbVA8NuKwqbfEZta3jafwk3HgIyQmDBU7gMYLWS0Z5GX4HsNEsogMsxNslNrG+EWwOgs1myVF2Uplw5h+1gnErREocWDrQ6jMAJRNp5QT4qO0bouX" 
	]

service name = User.accountFor name

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