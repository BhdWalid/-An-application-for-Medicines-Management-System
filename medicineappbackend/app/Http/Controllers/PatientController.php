<?php

namespace App\Http\Controllers;

use App\Models\File;
use App\Models\pharmacy;
use App\Models\Prescription;
use App\Models\Product;
use App\Models\Renew;
use Illuminate\Http\Request;

class PatientController extends Controller
{
    public function patientFile($id)
    {
        $file = File::select('first_name','id_file','doctor_id_doctor','address' ,'phone_number','last_name','reason','id_account')->where("id_file", $id)
            ->join('doctor', 'file.doctor_id_doctor', '=', 'doctor.id_doctor')
            ->join('account AS doctor_account', 'doctor.account_id_account', '=', 'doctor_account.id_account')
            ->get();

        $patient = File::where("id_file", $id)
        ->join('patient', 'file.patient_id_patient', '=', 'patient.id_patient')
        ->join('account AS patient_account', 'patient.account_id_account', '=', 'patient_account.id_account')
        ->get();
    
        if (!$file) {
            return response()->json(['error' => 'File not found'], 404);
        }
    
        $prescription = Prescription::with('medicines')
            ->where('file_id_file', $id)->orderByDesc('id_order') 
            ->first();
    
        if (!$prescription){
            return response()->json([
                'file' => $file,
                'prescription' => null,
                'patient' => $patient
            ], 200);
        }
        $medicines = $prescription->medicines->map(function ($medicine) {
            return [
                'id_medicine' => $medicine->id_medicine,
                'price' => $medicine->price,
                'name_medicine' => $medicine->name_medicine,
                'quantity' => $medicine->pivot->quantity,
                'dose' => $medicine->pivot->dose,
                'description' => $medicine->pivot->description,
            ];
        });
    
        return response()->json([
            'file' => $file,
            'prescription' => [
                'id_order' => $prescription->id_order,
                'date' => $prescription->date,
                'state' => $prescription->state,
                'file_id_file' => $prescription->file_id_file,
                'medicines' => $medicines,
            ],
            'patient' => $patient

        ], 200);
    }

    public function getPatientFiles($id)
    {
        // Find the file by ID
        $files = File::where("patient_id_patient", $id)
    ->join('doctor', 'file.doctor_id_doctor', '=', 'doctor.id_doctor')
    
    ->join('account AS doctor_account', 'doctor.account_id_account', '=', 'doctor_account.id_account')
    ->get();

        // Check if the file exists
        if (!$files) {
            return response()->json(['error' => 'File not found'], 404);
        }

        // Return the file data
        return response()->json(['file' => $files], 200);
    }
    public function renew(Request $request)
    {
      
        Renew::create([
            'order_id_order' => $request->input('order_id_order'),
            'detail' => $request->input('detail'),
        ]);

        return response()->json([
            'message' => 'Renew sent successfully',
        ], 200);
    }
}
