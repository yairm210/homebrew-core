class HgFastExport < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/refs/tags/v250330.tar.gz"
  sha256 "1c4785f1e9e63e0ada87e0be5a7236d6889eea98975800671e3c3805b54bf801"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/frej/fast-export.git", branch: "master"

  depends_on "mercurial" => :test
  depends_on "python@3.14"

  # TODO: Switch back to formula after https://github.com/frej/fast-export/issues/348
  resource "mercurial" do
    url "https://www.mercurial-scm.org/release/mercurial-7.1.2.tar.gz"
    sha256 "ce27b9a4767cf2ea496b51468bae512fa6a6eaf0891e49f8961dc694b4dc81ca"
  end

  def install
    python3 = which("python3.14")
    libexec.install "plugins", "pluginloader"
    bin.install buildpath.glob("hg*.{sh,py}")

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("mercurial")
    venv_python = venv.root/"bin/python"

    rewrite_shebang python_shebang_rewrite_info(venv_python), *bin.children
    bin.env_script_all_files libexec/"bin", PYTHON: venv_python, PYTHONPATH: libexec
  end

  test do
    mkdir testpath/"hg-repo" do
      system "hg", "init"
      (testpath/"hg-repo/test.txt").write "Hello"
      system "hg", "add", "test.txt"
      system "hg", "commit", "-u", "test@test", "-m", "test"
    end

    mkdir testpath/"git-repo" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system bin/"hg-fast-export.sh", "-r", testpath/"hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_path_exists testpath/"git-repo/test.txt"
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
