class workstation::install {
#build classe -- check
#dynamic based on user
#based on OS


if $::id == 'root' {
  $userpath = "/root"
}
else{
  $userpath = "/home/${::id}"
}



 #Ensures vim and git and working directories are present

  package { 'vim-enhanced':
    ensure  => 'present',
}
  package{ 'git':
    ensure  => 'present',	
}
  file {["${userpath}/.vim","${userpath}/.vim/bundle/","${userpath}/.vim/autoload"]:
    ensure  => 'directory',
}

#Pulls down pathogen and places it in ~/.vim/autoload
exec { 'pathogen':
    command => '/usr/bin/curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim',
}

#creates the .vimrc file
 file { "${userpath}/.vimrc":
    ensure   => 'file',
    content  => "call pathogen#infect() \nsyntax on \nfiletype plugin indent on",
    require  => Exec['pathogen'],
}	

#Pullls down vim-puppet.vim and tabular and puts them in /bundle

  exec { 'vim-puppet':
    cwd      => "${userpath}/.vim/bundle",
    command  => "/usr/bin/git clone https://github.com/rodjek/vim-puppet.git; /usr/bin/git clone https://github.com/godlygeek/tabular.git;",
    require  => [File["${userpath}/.vim","${userpath}/.vim/bundle/","${userpath}/.vim/autoload"], Package['git']],
}

}
