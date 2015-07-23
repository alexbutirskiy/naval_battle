Gem::Specification.new do |s|
  s.name        = 'alex_butirskiy_sea_battle'
  s.version     = '0.1.0'
  s.date        = '2015-07-23'
  s.summary     = 'Sea battle game'
  s.description = <<-EOF
A simple computr game.  Just type sea_battle after installation
There are three modes of playing
EOF
  s.authors     = ["Alex Butirskiy"]
  s.email       = 'butirskiy@gmail.com'
  s.files       = ['lib/sea_battle/game.rb', 'lib/sea_battle/board.rb', 'lib/sea_battle/ship.rb', 'lib/sea_battle/cell.rb', 'lib/alex_butirskiy_sea_battle.rb', 'bin/sea_battle']
  s.require_paths = ['lib']
  s.executables << 'sea_battle'
  s.homepage    = 'https://github.com/alexbutirskiy/sea_battle'
  s.license       = 'MIT'
end