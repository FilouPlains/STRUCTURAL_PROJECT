#!/usr/bin/env python

# Homology modeling by the automodel class.

# Load standard Modeller classes.
from modeller import *
# Load the automodel class.
from modeller.automodel import *

# Request verbose output.
log.verbose()

# Create a new MODELLER environment to build this model in.
env = environ()

# Read in HETATM records from template PDBs.
env.io.hetatm = True

a = automodel(
    env,
    # Alignment filename.
    alnfile="align.ali",
    # codes of the templates.
    knowns=["7THH", "6WUU", "7KAG", "7T9W", "7LGO", "6WOJ", "2KQV", "2W2G",
            "4XW3"],
    # Code of the target.
    sequence="P0DTC1",
    assess_methods=(assess.DOPE, assess.GA341)
)

# Index of the first model.
a.starting_model = 1
# Index of the last model.
a.ending_model = 100

# Do the actual homology modeling.
a.make()
