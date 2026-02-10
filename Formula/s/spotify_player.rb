class SpotifyPlayer < Formula
  desc "Command driven spotify player"
  homepage "https://github.com/aome510/spotify-player"
  url "https://github.com/aome510/spotify-player/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "b09ae88647758003eb7c666d3c2f60e1ff7624a14f9e8244332afe2b46167c4f"
  license "MIT"
  head "https://github.com/aome510/spotify-player.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ca859c6b5bdde5250a69af54c5875e343eaa1518ec343753703c9a2667ab749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f367c7373701c98bcbd956e20ed020a0b2a9ebc9138105e2db09730994995d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8d52b52aec4d019d3855ed9c7e3c409b33e2c40122bbfd6b2af31376e35466"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb607fbc690d688230b7c4694b395c18394be3d9b8540661f656fc76461e6d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2d545844616419bc1bb2e9b0aac28ec99389cdb9111827004524cb5e7549ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f904593cc645dc9c8c1db5592febeaed1e2a4845ef1d84392d6fb6121ffb91"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features", "image,notify", *std_cargo_args(path: "spotify_player")
    bin.install "target/release/spotify_player"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spotify_player --version")

    cmd = "#{bin}/spotify_player -C #{testpath}/cache -c #{testpath}/config 2>&1"
    _, stdout, = Open3.popen2(cmd)
    assert_match "https://accounts.spotify.com/authorize", stdout.gets("\n")
  end
end
