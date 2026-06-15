<?php

use StubsGenerator\Finder;

return Finder::create()
    ->in( array(
        'source/forminator',
    ) )
    ->append(
        Finder::create()
            ->in(['source/forminator'])
            ->files()
            ->depth('< 1')
            ->path('forminator.php')
    )
    // ->notPath('customizer')
    // ->notPath('debug')
    ->sortByName(true)
;
