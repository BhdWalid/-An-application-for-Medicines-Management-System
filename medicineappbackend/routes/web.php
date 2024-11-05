<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\AccountController;

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::controller(AccountController::class)->group(function () {
     Route::post('/CreateAccount', 'CreateAccount')->name('CreateAccount');

});


Route::controller(AdminController::class)->group(function () {
    Route::get('/', 'showLoginForm')->name('login');
    Route::post('log', 'log')->name('log');
    //Route::get('dashboard', 'showdashboard')->name('dashboard');
    Route::get('information', 'showinformation')->name('information');
    Route::get('Account_creation_requests', 'showcreate_account')->name('Account_creation_requests');
    Route::get('account_reclamation', 'showAllComplaints')->name('account_reclamation');
    Route::delete('complaints/{id}',  'destroy')->name('complaints.destroy');
    Route::get('create_account', 'show_create_account')->name('create_account');
    Route::post('/create_account', 'CreateAccount')->name('CreateAccount');
    
    Route::get('create_medicine', 'show_create_medicine')->name('create_medicine');

    Route::post('/create_medicine', 'CreateMedicine')->name('create_medicine');
    Route::get('manageMedicines', 'manageMedicines')->name('manageMedicines');
    Route::post('Edit/Medicine', 'editMedicine')->name('editMedicine');
    Route::post('Update/update_medicine', 'update_medicine')->name('update_medicine');
    Route::post('destroyMedicine', 'destroyMedicine')->name('destroyMedicine');


    Route::get('dashboard', 'dashboard')->name('dashboard');
    Route::get('manageAccounts', 'manage')->name('manageAccounts');
    Route::get('logout', 'logout')->name('logout');
    Route::get('Manage/Students', 'manage')->name('manageStudent');
    Route::post('Store/Student', 'store')->name('storeStudent');
    Route::post('Destroy/Student', 'destroyAccount')->name('destroyAccount');
    Route::post('Edit/Student', 'edit')->name('editStudent');
    Route::post('Update/Student', 'update')->name('updateStudent');
    Route::get('Edit/Student/Password/{id}',  'editStudentPassword')->name('editStudentPassword');
    Route::get('Show/Students/Excluded',  'displayExcludedStudents')->name('displayExcludedStudents');


    Route::get('accountreclamation', 'showAllreclamation')->name('accountreclamation');
    Route::post('destroyComplaint', 'destroyComplaint')->name('destroyComplaint');
});


