class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.0.3/flyway-commandline-12.0.3.tar.gz"
  sha256 "d2210b02243582f9d21d93d8a5186a47d3e2aff34ee56c0b0729c734572726bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "21bfdfca99dc3b307d1a3a01367f9f1fda4c990552ff3e9b66fe99b1fce032c9"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flyway --version")

    assert_match "Successfully validated 0 migrations",
      shell_output("#{bin}/flyway -url=jdbc:h2:mem:flywaydb validate")
  end
end
