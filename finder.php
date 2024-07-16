<?php

return \StubsGenerator\Finder::create()
    ->in( array(
        'source/forminator',
    ) )
    ->append(
        \StubsGenerator\Finder::create()
            ->in(['source/forminator'])
            ->files()
            ->depth('< 1')
            ->path('forminator.php')
    )
    // ->notPath('customizer')
    // ->notPath('debug')
    ->sortByName(true)
;
