class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://github.com/lepture/python-livereload"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/37/1d/0a336abf618272d53f62ebe274f712e213f5a03c0b2339575430b8362ef2/tornado-6.5.4.tar.gz"
    sha256 "a22fa9047405d03260b483980635f0b041989d8bcc9a313f8fe18b411d84b1d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"index.html").write <<~EOS
      <h1>Hello, world!</h1>
    EOS

    port = free_port
    pid = spawn bin/"livereload", testpath, "--port=#{port}"

    begin
      sleep 5
      output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/index.html")
      assert_match "<h1>Hello, world!</h1>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
