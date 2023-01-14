#!/bin/bash

for target in burgerbox_friesbox_full friesbox_only burgerbox_without_base base_only multimaterial_burgerbox_without_base multimaterial_smile multimaterial_m_macdo
do
	echo ${target}
	openscad -q -o ${target}.stl -p parameters.json -P ${target} macdo.scad
done


