Tests for directory targets that are produced by unsandboxed rule

  $ cat > dune-project <<EOF
  > (lang dune 3.4)
  > (using directory-targets 0.1)
  > EOF

Build directory target from the command line without sandboxing

  $ cat > dune <<EOF
  > (rule
  >  (targets (dir output))
  >  (action (system "mkdir output; echo x > output/x; echo y > output/y")))
  > EOF

  $ dune build output/x
  $ cat _build/default/output/x
  x
  $ cat _build/default/output/y
  y

We ask to build a file that doesn't exist inside the directory:

  $ dune build output/fake
  File "dune", line 1, characters 0-102:
  1 | (rule
  2 |  (targets (dir output))
  3 |  (action (system "mkdir output; echo x > output/x; echo y > output/y")))
  Error: This rule defines a directory target "output" that matches the
  requested path "output/fake" but the rule's action didn't produce it
  [1]

When we fail to create the directory, dune complains:

  $ cat > dune <<EOF
  > (rule
  >  (targets (dir output))
  >  (action (system "true")))
  > EOF

  $ dune build output/
  File "dune", line 1, characters 0-56:
  1 | (rule
  2 |  (targets (dir output))
  3 |  (action (system "true")))
  Error: Rule failed to produce directory "output"
  [1]
