<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class MakeExec implements ShouldQueue
{
    //queue
    use Queueable, InteractsWithQueue, SerializesModels;

    public function compiling()
    {
        //compiling logic
    }
}
