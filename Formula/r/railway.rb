class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.30.0.tar.gz"
  sha256 "b9423102e0af2f77744a01aa3c09be269d85b1611997f2c38d1ae7faab534b47"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba6e537eca43a0d870da77da5231b61abae8b331945d288a951b7e7796d47a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b24928a7380d31c7e91594f65e15ca5bc39aa712ab0124303b8fafc233042a2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fbad7ac213c87be5ab8444f691dc1d576bf90f750e76a20106e2a79160491e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c9596a5f33ce4b8cc6367794c712738e5864b78ddd19091dd4117dfafcc53d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927fc4e2b7692c198aee810fa9341db69e330cd3e2b08f7a43faefaf5f8a308e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34c8eb3544c764fdad3ced883399926cde92120a57daa0c33998cf059681f61d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
