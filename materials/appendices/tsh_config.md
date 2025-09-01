# External Access (via Teleport)

Detailed instructions from the [Sanger documentation](https://sanger.freshservice.com/support/solutions/articles/53000059623-remote-access-to-sanger-via-ssh).

### 1. Authenticate Teleport session

```bash
tsh login --proxy=portal.sanger.ac.uk:443 --auth=okta
```

### 2. List accessible nodes

```bash
tsh ls
```

### 3. Connect to a node via tsh (optional)

```bash
tsh ssh <your_username>@farm22-head1.internal.sanger.ac.uk
```

### 4. Connect via plain SSH using configured ~/.ssh/config

```bash
ssh farm22-head1.internal.sanger.ac.uk
```

### 5. Transfer files using SCP

```bash
scp local_file <your_username>@farm22-head1.internal.sanger.ac.uk:/path/to/destination/
scp <your_username>@farm22-head1.internal.sanger.ac.uk:/remote/file ./local_copy
```

### 6. Transfer files using RSYNC

```bash
rsync -avz -e ssh local_file <your_username>@farm22-head1.internal.sanger.ac.uk:/path/to/destination/
rsync -avz -e ssh <your_username>@farm22-head1.internal.sanger.ac.uk:/remote/file ./local_copy
```

---

## Internal Participants (inside Sanger network)

### 1. Connect via SSH

```bash
ssh farm22-head1.internal.sanger.ac.uk
```

### 2. Transfer files via SCP

```bash
scp local_file username@farm22-head1.internal.sanger.ac.uk:/path/to/destination/
```

### 3. Transfer files via RSYNC

```bash
rsync -avz local_file username@farm22-head1.internal.sanger.ac.uk:/path/to/destination/
```

> Notes:
> - Participants inside the network do **not** need `tsh` or Teleport config.
> - Your SSH config already handles keeping connections alive and forwarding X11/agent." > sanger_hpc_cheatsheet.md
