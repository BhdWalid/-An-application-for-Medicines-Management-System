<?php

namespace App\Http\Controllers;

use App\Models\file;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\DB;

class Controller extends BaseController
{
    public function search(file $id)
    {
        return file::find($id);
    }
    //hdi l function t3 show mb3d ndirouha m3a patient 
    public function show($id)
    {
        $file = DB::table("files")
            ->join("doctors", "files.id", "=", "doctors.id")
            ->select("files.*", "doctors.name", "doctors.email")
            ->where("files.id", "=", $id)
            ->get()
            ->first();
        return $file;
    }

    use AuthorizesRequests, ValidatesRequests;
}
