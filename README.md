# stranger-loops-talk

Code from 'Strange Dreams of Stranger Loops' keynote for Strange Loop 2021.  Here is a video of the keynote talk:

https://www.youtube.com/watch?v=AffW-7ika0E


All code runs under Chez Scheme:

https://cisco.github.io/ChezScheme/


The code I write during the keynote can be found in `transcript.scm`.  I first load `simple.scm` into Chez Scheme in order to load miniKanren and `evalo`.  The Quine relay code can be found in `quine-relay.scm`.


The `faster-miniKanren` code is from https://github.com/michaelballantyne/faster-minikanren; the file `faster-miniKanren/q.scm` is a slightly modified version of the original `faster-minikanren/test-quines.scm` file (https://github.com/michaelballantyne/faster-minikanren/blob/master/test-quines.scm)


Thanks to Nada Amin, my partner in quine.  In the keynote I mention that Nada and I had been working on self-replicating programs in the relational setting, including very simple "relational viruses"; here is Nada's LiveCode showing examples of Relational Virology:

https://io.livecode.ch/learn/namin/relational-virology