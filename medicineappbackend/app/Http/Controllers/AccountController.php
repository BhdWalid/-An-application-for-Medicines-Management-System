<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Account;
use App\Models\Complaint;
use App\Models\Doctor;
use App\Models\File;
use App\Models\Patient;
use App\Models\Pharmacist;
use App\Models\Pharmacy;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class AccountController extends Controller
{
    public function CreateAccount(Request $request)
    {
        // Validate the request data
        $validatedData = [
            "first_name" => "required|string",
            "last_name" => "required|string",
            "email" => "required|string|unique:account",
            "phone_number" => "required|string|max:255|unique:account",
            "password" => "required|string",
            "type_user" => "required|in:doctor,patient,pharmacist",
            "address" => "required|string",
            "specialty" => "required_if:type_user,doctor",
            "birthday" => "required_if:type_user,patient|date",
            "doctor_id_doctor" => "required_if:type_user,patient",
            "reason" => "required_if:type_user,patient",
            "name" => "required_if:type_user,pharmacist",

        ];
        $validator = Validator::make($request->all(), $validatedData);

        // Check if the validation fails
        if ($validator->fails()) {
            // Return the validation errors
            return response()->json(['status' => false,'message'=>'Something went wrong', 'errors' => $validator->errors()],400);
        }

        // Create an account
        $account = Account::create([
            'first_name' => $request->input('first_name'),
            'last_name' => $request->input('last_name'),
            'type_user' => $request->input('type_user'),
            'email' => $request->input('email'),
            'phone_number' => $request->input('phone_number'),
            'address' => $request->input('address'),
            'status' => 'pending',
            'password' => bcrypt($request->input('password')),
        ]);

        // Retrieve the newly created account's ID
        $account_id = $account->id_account;

        // Create a user of the specified type
        if ($request->input('type_user') === 'doctor') {
            Doctor::create([
                'account_id_account' => $account_id,
                'specialty' => $request->input('specialty'),
                // Add other doctor-specific fields if needed
            ]);
        } elseif ($request->input('type_user') === 'patient') {
            $patient =  Patient::create([
                'account_id_account' => $account_id,
                'birthday' => $request->input('birthday'),
            ]);

            $file = File::create([
                'reason' => $request->input('reason'),
                'doctor_id_doctor' => $request->input('doctor_id_doctor'),
                'patient_id_patient' => $patient->id_patient,
            ]);
            print( $file );
        } elseif ($request->input('type_user') === 'pharmacist') {

            $pharmacy =  Pharmacy::create([
                'name'  => $request->input('name'),
                'location'  => $request->input('location'),
            ]);

            $id_pharmacy =  $pharmacy->id_pharmacy;

            Pharmacist::create([
                'account_id_account' => $account_id,
                'pharmacy_id_pharmacy' => $id_pharmacy,
                // Add other pharmacist-specific fields if needed
            ]);
        }

        return response()->json(['status' => true]);
    }



    public function login(Request $request)
    {
        $utilisateurDonne = $request;
        $typeUser = $utilisateurDonne["type_user"];
        $utilisateur = null;

        if ($typeUser === "doctor") {
            $utilisateur = Account::where("email", $utilisateurDonne["email"])
                ->where("type_user", "doctor")
                ->join('doctor', 'doctor.account_id_account', '=', 'id_account')
                ->first();
        } elseif ($typeUser === "patient") {
            $utilisateur = Account::where("email", $utilisateurDonne["email"])
                ->where("type_user", "patient")
                ->join('patient', 'patient.account_id_account', '=', 'id_account')
                ->first();
        } elseif ($typeUser === "pharmacist") {
            $utilisateur = Account::where("email", $utilisateurDonne["email"])
                ->where("type_user", "pharmacist")
                ->join('pharmacist', 'pharmacist.account_id_account', '=', 'id_account')
                ->first();
        } else {
            return response(["message" => "Invalid user type"], 400);
        }

        if (!$utilisateur) {
            return response(["message" => "No user found with the following email: $utilisateurDonne[email]"], 401);
        }
        
if (!Hash::check($utilisateurDonne["password"], $utilisateur->password)) {
    return response(["message" => "Wrong password"], 401);
}
if ($utilisateur->status === "pending" || $utilisateur->status === "refused") {
    return response(["message" => "Your account is pending"], 401);
}


       // $token = $utilisateur->createToken("CLE_SECRETE")->plainTextToken;

        return response([
            "utilisateur" => $utilisateur,
            //"token" => $token
        ], 200);
    }

    public function addComplaint(Request $request)
    {
      
        $complaint =  Complaint::create([
            'sender' => $request->input('sender'),
            'resiver' => $request->input('resiver'),
            'subject' => $request->input('subject'),
            'content' => $request->input('content'),
            'date' => Carbon::today()->format('Y-m-d'),
        ]);

        return response()->json([
            'message' => 'Complaint sent successfully',
            'file' => $complaint,
        ], 200);
    }

    public function accountComplait(Request $request)
    {
      
        $complaint =  Complaint::create([
            'sender' => $request->input('sender'),
            'resiver' => 4,
            'subject' => $request->input('subject'),
            'content' => $request->input('content'),
            'date' => Carbon::today()->format('Y-m-d'),
        ]);

        return response()->json([
            'message' => 'Account Complaint sent successfully',
            'file' => $complaint,
        ], 200);
    }

    public function inBox(Request $request)
    {
        
        $messages =  Complaint::where('resiver' , $request->input('id'))
        ->join('account', 'sender', '=', 'id_account')
        ->select('complaint.*', 'account.first_name', 'account.last_name')
        ->get();

        return response()->json([
           'messages' => $messages
        ], 200);
    }

    public function message(Request $request)
    {
        
        $messages =  Complaint::where('id_complaint' , $request->input('id'))
        ->join('account', 'sender', '=', 'id_account')
        ->select('complaint.*', 'account.first_name', 'account.last_name')
        ->get();

        return response()->json([
           'messages' => $messages
        ], 200);
    }

}
