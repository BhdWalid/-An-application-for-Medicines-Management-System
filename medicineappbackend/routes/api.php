<?php


use App\Http\Controllers\DoctorController;
use App\Http\Controllers\OrdonnanceController;
use App\Http\Controllers\PharmacistController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\PatientController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


//Pharmacy
Route::post("/addMedicine", [PharmacistController::class, "addMedicine"]);
Route::get("/allmedecine", [PharmacistController::class, "getAllMedicines"]);
Route::get("/medicinebypharmacy/{id}", [PharmacistController::class, "getMedicineBypharmacy"]);
Route::get("/medicinebystock/{id}", [PharmacistController::class, "getMedicineByStock"]);
Route::delete("/delete_prod/{stockId}", [PharmacistController::class, "deleteStock"]);
Route::put("/updateStock/{stockId}", [PharmacistController::class, "updateStock"]);
Route::post("/add_prod", [PharmacistController::class, "addTeStock"]);
Route::post("/addToMedicine", [PharmacistController::class, "addToMedicine"]);
Route::get("/getOrder/{id}", [PharmacistController::class, "getOrder"]);
Route::put("/acceptOrder/{id}", [PharmacistController::class, "acceptOrder"]);
Route::get("/getOrderDetail/{id}", [PharmacistController::class, "getOrderDetail"]);
Route::delete("/refuseOrder/{id}", [PharmacistController::class, "refuseOrder"]);


//Doctor
Route::post("/addFile", [DoctorController::class, "addFile"]);
Route::put("/updateFile/{id}", [DoctorController::class, "updateFile"]);
Route::delete("/deleteFile/{id}", [DoctorController::class, "deleteFile"]);
Route::get("/getFile/{id}", [DoctorController::class, "getFile"]);
Route::get("/getDoctorFiles/{id}", [DoctorController::class, "getDoctorFiles"]);
Route::post("/chossePharmacy", [DoctorController::class, "chossePharmacy"]);
Route::post("/createPres", [DoctorController::class, "CreatePrescription"]);
Route::post("/verifyEmail", [DoctorController::class, "verifyEmail"]);
Route::get("/viewRenows/{id}", [DoctorController::class, "viewRenows"]);
Route::delete("/refuseRenew/{id}", [DoctorController::class, "refuseRenew"]);



//patient
Route::get("/getPatientFiles/{id}", [PatientController::class, "getPatientFiles"]);
Route::get("/patientFile/{id}", [PatientController::class, "patientFile"]);
Route::post("/renew", [PatientController::class, "renew"]);



//System
Route::post("/CreerAccount", [AccountController::class, "CreateAccount"]);
Route::post("/login", [AccountController::class, "login"]);
Route::post("/addComplaint", [AccountController::class, "addComplaint"]);
Route::post("/accountComplait", [AccountController::class, "accountComplait"]);
Route::post("/inBox", [AccountController::class, "inBox"]);
Route::post("/message", [AccountController::class, "message"]);




Route::post("/creer/passerCommande", [DoctorController::class, "passerCommande"]);


Route::group(["middleware" => ["auth:sanctum"]], function () {
});


Route::group(["middleware" => ["auth:sanctum"]], function () {
});
