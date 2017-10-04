# MKD - Multiple-Kernel local-patch Descriptor

This is a Matlab package that implements the kernel local descriptor presented in "Multiple-Kernel Local-Patch Descriptor" at BMVC 2017 <https://arxiv.org/pdf/1707.07825.pdf>. 

<img src="http://cmp.felk.cvut.cz/~toliageo/images/thumbs/mkld.png" height="250"/>

## What is it?
This code implements:

1. Extraction of our local descriptor
2. Learning of the whitening with supervision
3. Learning and evaluation on the Photo Tourism patch dataset

## Execution
Run the following script to extract patch descriptor with a pre-computed configuration:

```
>> test_simple
```

Run the following script to extract descriptors, learn, and evaluate on the Photo Tourism dataset

```
>> test_phototourism
```

## Citation

If you use this work please cite our publication  "Multiple-Kernel Local-Patch Descriptor" at BMVC 2017 <https://arxiv.org/pdf/1707.07825.pdf>. 

```
@inproceedings{Mukundan17,
  title     = {Multiple-Kernel Local-Patch Descriptor},
  author    = {Mukundan, Arun and Tolias, Giorgos and Chum, Ondrej},
  booktitle = {British Machine Vision Conference},
  year      = {2017},
  url       = {https://arxiv.org/pdf/1707.07825.pdf}
}
```

## License

MKD is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
