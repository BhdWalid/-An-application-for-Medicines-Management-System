<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\account_reclamation;
use App\Models\admin;
use App\Models\complaint;
use App\Models\Doctor;
use App\Models\File;
use App\Models\Medicine;
use App\Models\Patient;
use App\Models\Pharmacist;
use App\Models\pharmacy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AdminController extends Controller
{
    
    public function log(Request $request)
    {
        $utilisateurDonne = $request;


        $utilisateur = Account::where("email", $utilisateurDonne["email"])
            ->where("type_user", "admin")
           // ->join('admin', 'admin.account_id_account', '=', 'id_account')
            ->first();
        
        if (!$utilisateur) {
            return view('login-index',["message" => "Invalid Email or password"]);
        }

        
if (!Hash::check($utilisateurDonne["password"], $utilisateur->password)) {
    return view('login-index',["message" => "Invalid Email or password"]);
}
if ($utilisateur->status === "pending" || $utilisateur->status === "refused") {
    return view('login-index',["message" => "Your account is pending or refused"]);
  
}


        return redirect()->route('dashboard');
    }
    public function showLoginForm()
    {
        return view('login-index',["message" => ""]);
    }
    public function showdashboard()
    {
        return view('dashboard');
    }
    public function showinformation()
    {
        return view('information');
    }
    public function showcreate_account()
    {

        $count = Account::count();

        $students = Account::where('status','=','pending')->get();
        $data = [
            'username' => 'Bahady',
            'students'   => $students,
            'count' => $count 
        ];

        return view('Account_creation_requests')->with($data);
    }
    public function showAllComplaints()
    {
        $complaints = complaint::where('resiver',1);
        return view('account_reclamation', ['complaints' => $complaints]);
    }
    public function destroy($id)
    {
        $complaint = complaint::findOrFail($id);
        $complaint->delete();

        return redirect()->back()->with('success', 'La plainte a été supprimée avec succès.');
    }

    public function destroyAccount(Request $request)
    {

        $student = Account::find($request->student_id);
        if($student==false) {
            return response()->json(['status' => false,'message'=>'Something went wrong','errors'=>'Student not found']);
        }
        $student->delete();
        
        return response()->json(['status' => true]);
        
        
    }
    public function show_create_account()
    {
        return view('createcompte');
    }

    public function dashboard()
    {
        
        $patientCount = Account::where('type_user', 'patient')->count();
        $doctorCount = Account::where('type_user', 'doctor')->count();
        $pharmacistCount = Account::where('type_user', 'pharmacist')->count();

        $data = [
            'username' => '',
            'patients_number'=>$patientCount ,
            'doctors_number'=>$doctorCount,
            'pharmacists_students'=>' ',
            'teachers_number'=>'  ',
            'pharmacists_number'=>$pharmacistCount,
            'month'=>'',
            'count'=>'',
            
        ];
        return view('admin.dashboard')->with($data);

    }
    public function manage()
    {
        $count = Account::count();

        $students = Account::all();
        $data = [
            'username' => 'Bahady',
            'students'   => $students,
            'count' => $count 
        ];

        
        return view('admin.student.manageStudent')->with($data);
    }
    public function logout()
    {
        $guards = array_keys(config('auth.guards'));
        foreach ($guards as $guard) {
            if (auth()->guard($guard)->check()) {
                auth($guard)->logout();
            }
            return redirect()->route('login');
        }
    }


    public function store(Request $request)
    {
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
            "name" => "required_if:type_user,pharmacist",

        ];
        $validator = Validator::make($request->all(), $validatedData);

        if ($validator->fails()) {
            return response()->json(['status' => false,"errors" => $validator->errors()], 400);
        }


        Account::create([
            'first_name' => $request->input('first_name'),
            'last_name' => $request->input('last_name'),
            'type_user' => $request->input('type_user'),
            'email' => $request->input('email'),
            'phone_number' => $request->input('phone_number'),
            'address' => $request->input('address'),
            'password' => bcrypt($request->input('password')),
        ]);

        return response()->json(['status' => true]);
    }
    public function edit(Request $request)
    {
        
        $student = Account::find($request->student_id);
        if($student==false) {
            return response()->json(['status' => false,'message'=>'Something went wrong']);
        }
        $view=view('admin.student.edit_form')->with('student', $student)->render();
        return response()->json(['status' => true,'view'=>$view]);
        
    }

    public function update(Request $request)
    {
        try {
            $student = Account::find($request->data['old_id_account']);
        } catch (\Throwable $th) {
            throw $th;
        }

        
        if($student==false) {
            return response()->json(['status' => false,'message'=>'Something went wrong']);
        }
       
       
        $validator=Validator::make($request->data,[
            'id_account' =>['required','numeric',"unique:account,id_account,$student->id_account,id_account"],
            "first_name" => "required|string",
            "last_name" => "required|string",
            "email" => "required|string",
            "phone_number" => "required|string|max:255,",
        
            "address" => "required|string",
            "status" => "required|string",

        ]);
        if($validator->fails()){
            $view=view('admin.student.create_form');

            return response()->json(['status' => false,'message'=>'Something went wrong', 'errors' => $validator->errors(),'view'=>$view]);
        }
      
            $student->update([
                'id_account' => $request->data['id_account'],
                'first_name' => $request->data['first_name'],
                'last_name' => $request->data['last_name'],
                'status' => $request->data['status'],
                'email' => $request->data['email'],
                'phone_number' => $request->data['phone_number'],
                'address' => $request->data['address'],
            ]);
      
       
            
        $view=view('admin.student.create_form')->render();
        return response()->json(['status' => true,'view'=>$view]);
    }

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
            //"birthday" => "required_if:type_user,patient|date",
            "doctor_id_doctor" => "required_if:type_user,patient",
            "reason" => "required_if:type_user,patient",
            "name" => "required_if:type_user,pharmacist",
            "location" => "required_if:type_user,pharmacist",
        

        ];
        $validator = Validator::make($request->all(), $validatedData);

        // Check if the validation fails
        if ($validator->fails()) {
            // Return the validation errors
            if ($validator->fails()) {

                return redirect()->back()->withErrors($validator)->withInput();                }        }

        // Create an account
        $account = Account::create([
            'first_name' => $request->input('first_name'),
            'last_name' => $request->input('last_name'),
            'type_user' => $request->input('type_user'),
            'email' => $request->input('email'),
            'phone_number' => $request->input('phone_number'),
            'address' => $request->input('address'),
            'status' => 'accept',
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

        return redirect()->back()->with('success', 'Account created successfully.');
    }


  /*  public function destroy(Request $request)
    {

        $student = Student::find($request->student_id);
        if($student==false) {
            return response()->json(['status' => false,'message'=>'Something went wrong','errors'=>'Student not found']);
        }
        $student->delete();
        
        return response()->json(['status' => true]);
        
        
    }*/
    public function manageMedicines()
    {

        $students = Medicine::all();
        $data = [
            'username' => 'Bahady',
            'students'   => $students,
            'count' => 1 
        ];

        
        return view('admin.student.manageMedicine')->with($data);
    }
    public function CreateMedicine(Request $request)
{
    // Validate the request data
    $info = [
        'name_medicine' => 'required|string|unique:medicine,name_medicine',
        'price' => 'required|numeric',
        'bar_code' => 'required|string|unique:medicine',
        'image' => 'nullable|string',
    ];
    $validator = Validator::make($request->all(), $info);

    if ($validator->fails()) {
        return redirect()->back()->withErrors($validator)->withInput();
    }

    $name_medicine = $request->input('name_medicine');
    $price = $request->input('price');
    $image = $request->input('image');
    $bar_code = $request->input('bar_code');

    try {
        // Create a new Medicine instance
        Medicine::create([
            'name_medicine' => $name_medicine,
            'price' => $price,
            'image' => $image,
            'bar_code' => $bar_code,
        ]);

        return redirect()->back()->with('success', 'Medicine created successfully.');
    } catch (\Exception $e) {
        // Handle the exception and redirect back with an error message
        return redirect()->back()->with('error', 'Failed to create medicine. Please try again.');
    }
}
    public function show_create_medicine()
    {
        return view('createmedicine');
    }


    public function editMedicine(Request $request)
    {
        
        $student = Medicine::find($request->student_id);
        if($student==false) {
        return response()->json(['status' => false, 'message' => 'Medicine not found']);
        }
        
        $view=view('admin.student.edit_medicine')->with('medicine', $student)->render();
        return response()->json(['status' => true,'view'=>$view]);
        
    }



    public function update_medicine(Request $request)
    {
        
        $student = Medicine::find($request->data['id_medicine']);
        if($student==false) {
            return response()->json(['status' => false,'message'=>'Something went wrong']);
        }
       
       
        $validator=Validator::make($request->data,[
            'id_medicine' =>['required','numeric',"unique:medicine,id_medicine,$student->id_medicine,id_medicine"],
            'price' => 'required|numeric',
            'bar_code' => ['required','string',"unique:medicine,bar_code,$student->bar_code,bar_code"],
            'image' => 'nullable|string',

        ]);
        if($validator->fails()){
            
            return redirect()->back()->withErrors($validator)->withInput();

        }
      
            $student->update([
                'id_medicine' => $request->data['id_medicine'],
                'price' => $request->data['price'],
                'bar_code' => $request->data['bar_code'],
                'image' => $request->data['image'],
            ]);
      
       
            
        $view=view('admin.student.medicine_form')->render();
        return response()->json(['status' => true,'view'=>$view]);
    }


    public function destroyMedicine(Request $request)
    {

        $student = Medicine::find($request->student_id);
        if($student==false) {
            return response()->json(['status' => false,'message'=>'Something went wrong','errors'=>'Student not found']);
        }
        $student->delete();
        
        return response()->json(['status' => true]);
        
        
    }
    
    public function showAllreclamation()
    {
        $complaints = Complaint::where('resiver', 4)->get();
        return view('admin.justification', ['complaints' => $complaints , 'username' => 'Bahady',
        'count' => 1 ]);
    }

    public function destroyComplaint(Request $request)
    {
        $complaint = Complaint::find($request->student_id);
        if ($complaint == false) {
            return response()->json(['status' => false, 'message' => 'Something went wrong', 'errors' => 'Student not found']);
        }
        $complaint->delete();

        return response()->json(['status' => true]);
    }

}
