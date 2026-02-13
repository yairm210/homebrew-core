class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://cruise.umple.org/umple/"
  url "https://github.com/umple/umple/releases/download/v1.36.0/umple-1.36.0.8088.f0fbd82bc.jar"
  version "1.36.0"
  sha256 "bc29c60a4bf65120097295f347ab20085b0be376661d6779f8d380f3e9470618"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f29200d94979325078d9073338ed60413e7cde1392125b72d43e1e2105e8d3a"
  end

  depends_on "openjdk"

  def install
    filename = File.basename(stable.url)

    libexec.install filename
    bin.write_jar_script libexec/filename, "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system bin/"umple", "test.ump", "-c", "-"
    assert_path_exists testpath/"X.java"
    assert_path_exists testpath/"X.class"
  end
end
