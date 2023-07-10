<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;
use App\Jobs\MakeExec;

class Controller extends BaseController
{
    //
    public function compileExe()
    {
        dispatch(new \App\Jobs\MakeExec());
    }
}
