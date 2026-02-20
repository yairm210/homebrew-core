class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "d4df925f09c646e0b453156f3797b5a80119d699a33b85d792ef20bfd7279308"
  license "Apache-2.0"

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-Dmaven.test.skip=true", "package"
    libexec.install Dir["structurizr-application/target/structurizr-*.war"].first => "structurizr.war"
    bin.write_jar_script libexec/"structurizr.war", "structurizr"
  end

  test do
    result = shell_output("#{bin}/structurizr validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-*: #{version}", shell_output("#{bin}/structurizr version")
  end
end
