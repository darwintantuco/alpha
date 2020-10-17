const { exec, execSync } = require('child_process')
exec('git rev-parse --abbrev-ref HEAD', (err, stdout, stderr) => {
  execSync(`current_branch="${stdout.trim()}" bats --tap ./tests/*.bats`, {
    encoding: 'utf-8',
    stdio: 'inherit'
  })
})
