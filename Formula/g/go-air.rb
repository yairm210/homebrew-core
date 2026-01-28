class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.64.4.tar.gz"
  sha256 "69c0dbc71d434203c99ae41155ffa5b0a1e46699fcf4e2d14727d429ce290aa2"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = [
      "-s", "-w",
      "-X", "'main.BuildTimestamp=#{time.iso8601}'",
      "-X", "'main.airVersion=v#{version}'",
      "-X", "'main.goVersion=#{Formula["go"].version}'"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end
