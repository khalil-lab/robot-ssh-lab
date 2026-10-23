# Robot SSH Lab

An end-to-end test setup for a small command-line service running on a remote
Linux host. A Docker container provides the SSH target; Robot Framework drives
the tests over a real SSH connection.

This is the kind of harness used to validate embedded or industrial devices that
only expose a shell: the test suite verifies command output, stderr, and exit
codes exactly as they arrive over the wire.

## Topology

```text
 host                              Docker container (Debian)
 -----                             --------------------------
 Robot Framework  -- SSH :2222 --> sshd (user: tester)
   test_ssh.robot                    /usr/local/bin/sensor_app
```

## Tests

| Test | Expectation |
| --- | --- |
| Normal temperature | `25` returns `STATUS: NORMAL`, exit code 0 |
| High temperature | `85` returns `WARNING: HIGH_TEMPERATURE`, exit code 0 |
| Invalid input | `abc` writes `ERROR: invalid temperature` to stderr, exit code 2 |

## Run it

Generate a throwaway SSH key pair for the test user (private keys are ignored by
Git):

```bash
./scripts/gen-keys.sh
```

Start the target:

```bash
docker build -t robot-ssh-lab .
docker run -d --name robot-ssh-lab -p 2222:22 robot-ssh-lab
```

Install the test dependencies and run the suite:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install robotframework robotframework-sshlibrary
robot --outputdir results test_ssh.robot
```

Robot writes `output.xml`, `log.html`, and `report.html` under `results/`.

Stop the target:

```bash
docker rm -f robot-ssh-lab
```

## Security notes

- SSH password authentication and root login are disabled in the image.
- The key pair is generated locally for testing and is not committed.
- The container is a disposable test target, not a production hardening example.

## License

MIT. See [LICENSE](LICENSE).
