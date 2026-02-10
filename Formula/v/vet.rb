class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "9ed03582f4eedc97e5442ba1dd0d575cab2cc1fca6b6bb2da043b79f02fb74e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d77ee2227fb4b106d93cc774303e08a6605401de636c1a787d2c2a169342015"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3664b2f58df2e0d11eee7b4cf5741d55c143e4daee0e430d2a3d53d9ca6b373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc5ff37e83fb1b9832b244261153075b4d02e2a49b5a9b6241f9820335fc20a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb316a84f304db78b7b6a8bd9c43d3b88aa074b2ce07920736916bfdf1690420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45d1af4cfe49e376ee39fa51e514ae809c0c1b439b2fc6b85028fe45538a4f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4480a5af0dee7155a79ddb79a59769206896dcfcd96b79605ef4499a3148e6"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
