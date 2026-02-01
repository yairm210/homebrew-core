class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby/archive/refs/tags/3.0.2.tar.gz"
  sha256 "33b951be8969570726bc34632fa5e0f332ee6e8ed782b5ec0f8fd5629a6be959"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  uses_from_macos "ruby" => :build

  def install
    ENV["MRUBY_CONFIG"] = buildpath/"build_config/default.rb"
    system "rake"
    bin.install Dir["build/host/bin/*"]
    lib.install Dir["build/host/lib/*"]
    include.install Dir["include/*"]
  end

  test do
    output = shell_output("#{bin}/picoruby -e \"puts 'Hello, PicoRuby!'\"")
    assert_match "Hello, PicoRuby!", output
  end
end
