class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "3b94d57fa545a3ec727a5157b5732f4543760b082c3e1cd2ae0fe3f16beb41dd"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38158d51025c268f200e2fdbb95c77eb509d43dac7b016dd4683a263ae1f2940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38158d51025c268f200e2fdbb95c77eb509d43dac7b016dd4683a263ae1f2940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38158d51025c268f200e2fdbb95c77eb509d43dac7b016dd4683a263ae1f2940"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a669b31d4c2df2254aa34c937be9a81a2ed7071b6cd643cdae64b08e759959b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb7ad960a70d6cd83fa2cb7836c8547f7f4bc4d8fa7eee8646ee124a0d4135e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "761baabf04a7346c5e689ad85927033b153f69419ddba44bcae2b536af5b7df3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:\t v#{version}", shell_output("#{bin}/jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output("#{bin}/jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
