function rbinstall() {
  command ruby-install ruby $(cat .ruby-version) > /dev/null
  gem install bundler pry
}

each-ruby() {
  for ruby in $(command ls ~/.rubies); do
    chruby "$ruby"
    $*
  done
}
