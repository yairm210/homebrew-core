class Recur < Formula
  desc "Retry a command with exponential backoff and jitter"
  homepage "https://github.com/dbohdan/recur"
  url "https://github.com/dbohdan/recur/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "4009481a1fd752e50373f17cef5281332de451a3dd0d4ac1c268be380e52e1e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5392d17cf9cb538670069b7839997a2b93fc5c6837a02f02635c4158e02cbd8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5392d17cf9cb538670069b7839997a2b93fc5c6837a02f02635c4158e02cbd8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5392d17cf9cb538670069b7839997a2b93fc5c6837a02f02635c4158e02cbd8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f06404f8cf2721a04dc830aa34e57e6423240e338f9e9bb206b414102cbc91db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10fbf68bf8534b8da77219022f293a2d9a645177c5b0103c9720eec11f409d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449631dac11467bbf63e592474b0ed5424b4cf2ce974aaf669a263325e6764ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/recur -c 'attempt == 3' sh -c 'echo $RECUR_ATTEMPT'")
    assert_equal "1\n2\n3\n", output
  end
end
