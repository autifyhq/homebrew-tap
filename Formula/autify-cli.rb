# CAVEAT: Do not modify this file manually.
# This file is auto-generated by GitHub Actions of autify-cli.
# Edit https://github.com/autifyhq/autify-cli/blob/main/autify-cli.rb instead.

class AutifyCli < Formula
  desc "Autify Command Line Interface (CLI)"
  homepage "https://github.com/autifyhq/autify-cli"
  url "https://github.com/autifyhq/autify-cli", using: :git, revision: "eb9a7a8"
  version "0.12.0"
  # sha256 ""
  license "MIT"

  def install
    system "curl #{taball_url} | tar xz"
    inreplace "autify/bin/autify", /^CLIENT_HOME=/, "export AUTIFY_OCLIF_CLIENT_HOME=#{lib}/client\nCLIENT_HOME="
    libexec.install Dir["autify/*"]
    bin.install_symlink libexec/"bin"/"autify"
  end

  test do
    assert_match "autify-cli/#{version}", shell_output("#{bin}/autify --version")
  end

  private

  def taball_url
    package = JSON.parse(File.read("./package.json"), symbolize_names: true)
    raise "Version mismatch: #{package[:version]}" unless package[:version] == version

    bucket = package.dig(:oclif, :update, :s3, :bucket)
    folder = package.dig(:oclif, :update, :s3, :folder)
    sha = `git rev-parse --short HEAD`.strip
    uname_os = `uname`.strip
    os = case uname_os
    when /darwin/i
      "darwin"
    when /linux/i
      "linux"
    else
      raise "Unsupported os: #{uname_os}"
    end
    uname_arch = `uname -m`.strip
    arch = case uname_arch
    when /x86_64/i
      "x64"
    when /aarch/i
      "arm"
    when /arm64/i
      "arm64"
    else
      raise "Unsupported arch: #{uname_arch}"
    end
    "https://#{bucket}.s3.amazonaws.com/#{folder}/versions/#{version}/#{sha}/autify-v#{version}-#{sha}-#{os}-#{arch}.tar.gz"
  end
end
