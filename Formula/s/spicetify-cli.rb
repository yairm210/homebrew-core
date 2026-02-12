class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.42.10/v2.42.10.tar.gz"
  sha256 "b001354eabbaa165433a6ced8c0e0c590a40464a5b7a6fbaf7328a83bd7c0cc3"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1a3ac199ee53c04446def180a63c244fbd445e05fe3eed480ce832af5f30791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a3ac199ee53c04446def180a63c244fbd445e05fe3eed480ce832af5f30791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a3ac199ee53c04446def180a63c244fbd445e05fe3eed480ce832af5f30791"
    sha256 cellar: :any_skip_relocation, sonoma:        "be34b3e65c367a4ae144e07734fa060c780804f7eb89cfe6654608abb552e292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e18a6afb3604d396e145be41225adec740ab5073927a35b59dca5d12d23c4559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2204d145e3f877ef9960b6c4cc0bdc8d4ade12c5b9e14d7a3151dc57065f8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec/"spicetify"
    end
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file

    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end
