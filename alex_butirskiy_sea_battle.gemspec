Gem::Specification.new do |s|
  s.name        = 'alex_butirskiy_sea_battle'
  s.version     = '0.0.2'
  s.date        = '2015-07-12'
  s.summary     = 'Sea battle game'
  s.description = <<-EOF
A simple computr game.  Just type sea_battle after instalation


Only the demo mode (Computer vs Computer) works at the momemt/..
EOF
  s.authors     = ["Alex Butirskiy"]
  s.email       = 'butirskiy@gmail.com'
  s.files       = ['lib/game.rb', 'lib/board.rb', 'lib/ship.rb', 'lib/cell.rb', 'lib/alex_butirskiy_sea_battle.rb', 'bin/sea_battle']
  s.require_paths = ['lib']
  s.executables << 'sea_battle'
  s.homepage    = 'https://github.com/alexbutirskiy/sea_battle'
  s.license       = 'MIT'
end