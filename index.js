const core = require('@actions/core');
const exec = require('@actions/exec');
const path = require('path');
const os = require('os');

async function run() {
  try {
    const platform = core.getInput('platform');
    const arch = core.getInput('arch');
    core.info(`Building for ${platform} (${arch})`);

    let script = `build-${platform}.sh`;
    let shell = 'bash';
    if (os.platform() === 'win32' && platform === 'windows') {
      script = 'build-windows.ps1';
      shell = 'pwsh';
    }

    const scriptPath = path.join(__dirname, 'scripts', script);
    await exec.exec(shell, [scriptPath, arch]);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
