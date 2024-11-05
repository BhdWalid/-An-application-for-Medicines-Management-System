<?php

namespace App\Http\Controllers;

use App\Models\Complaint;
use App\Models\File;
use App\Models\Pharmacist;
use App\Models\Medicine;

use App\Models\Stock;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\Pharmacy;
use App\Models\Prescription;
use Carbon\Carbon;

class PharmacistController extends Controller
{
    public function addTeStock(Request $request)
    {

        $info = [
            'id_medicine' => 'required|exists:medicine,id_medicine',
            'id_pharmacy' => 'required|exists:pharmacy,id_pharmacy',
            'quantity' => 'nullable|integer',
            'date_f' => 'nullable|date',
            'date_e' => 'nullable|date',
        ];
        $validator = Validator::make($request->all(), $info);

        if ($validator->fails()) {

            return response()->json(['errors' => $validator->errors()], 400);
        }

        $medicineId = $request->input('id_medicine');
        $pharmacyId = $request->input('id_pharmacy');
        $quantity = $request->input('quantity');
        $dateF = $request->input('date_f');
        $dateE = $request->input('date_e');

        $medicine = Medicine::find($medicineId);
        if (!$medicine) {
            return response()->json(['error' => 'Le médicament spécifié n\'existe pas'], 404);
        }

        $pharmacy = Pharmacy::find($pharmacyId);
        if (!$pharmacy) {
            return response()->json(['error' => 'La pharmacie spécifiée n\'existe pas'], 404);
        }

        $stock = new Stock();
        $stock->medicine_idmedicien = $medicineId;
        $stock->pharmacy_id_pharmacy = $pharmacyId;
        $stock->quantity = $quantity;
        $stock->date_f = $dateF;
        $stock->date_e = $dateE;
        $stock->save();

        return response()->json([
            'message' => 'Le médicament a été ajouté au stock avec succès',
            'stock' => $stock
        ], 200);
    }

    public function addToMedicine(Request $request)
    {

        $info = [
            'name_medicine' => 'required|string|unique:medicine,name_medicine',
            'price' => 'required|numeric',
            'bar_code' => 'required|string|unique:medicine',
            'image' => 'nullable|string',
        ];
        $validator = Validator::make($request->all(), $info);

        if ($validator->fails()) {

            return response()->json(['errors' => $validator->errors()], 400);
        }

        $name_medicine = $request->input('name_medicine');
        $price = $request->input('price');
        $image = $request->input('image');
        $bar_code = $request->input('bar_code');
     
        


        $medicine = new Medicine();
        $medicine->name_medicine = $name_medicine;
        $medicine->price = $price;
        $medicine->image = $image;
        $medicine->bar_code = $bar_code;
        $medicine->save();

        return response()->json([
            'message' => 'Le médicament a été ajouté au med$medicine avec succès',
            '   medicine' => $medicine
        ], 200);
    }

    public function updateStock(Request $request, $stockId)
    {
        // Validate the request data
        $info = [
            'quantity' => 'nullable|integer',
            'date_f' => 'nullable|date',
            'date_e' => 'nullable|date',
        ];
        $validator = Validator::make($request->all(), $info);

        // Check if the validation fails
        if ($validator->fails()) {
            // Return the validation errors
            return response()->json(['errors' => $validator->errors()], 400);
        }

        // Check if the stock exists in the "stock" table using Eloquent
        $stock = Stock::find($stockId);
        if (!$stock) {
            return response()->json(['error' => 'Le stock spécifié n\'existe pas'], 404);
        }

        // Update the stock with the provided data
        $stock->quantity = $request->input('quantity', $stock->quantity);
        $stock->date_f = $request->input('date_f', $stock->date_f);
        $stock->date_e = $request->input('date_e', $stock->date_e);
        $stock->save();

        // Return the response with the updated stock details
        return response()->json([
            'message' => 'Le stock a été mis à jour avec succès',
            'stock' => $stock
        ], 200);
    }
    public function deleteStock($stockId)
    {
        // Find the stock by ID
        $stock = Stock::find($stockId);

        // Check if the stock exists
        if (!$stock) {
            return response()->json(['error' => 'Le stock spécifié n\'existe pas'], 404);
        }

        // Delete the stock
        $stock->delete();

        // Return a success message
        return response()->json(['message' => 'Le stock a été supprimé avec succès'], 200);
    }
    public function getMedicineByStock($id)
    {
       /* $info = [
            'id_stock' => 'required|exists:stock,id_stock',
        ];
        $validator = Validator::make($request->all(), $info);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }
        
        $stockId = $request->input('id_stock');*/
       
        $stock = Stock::where('id_stock' , $id)
        ->join('medicine', 'medicine_idmedicien', '=', 'id_medicine')
        ->get();
/*
        if (!$stock) {
            return response()->json(['error' => "The medicine dosn't exist"], 404);
        }
        $medicineId = $stock->medicine_idmedicien;
        $medicine = Product::find($medicineId);

        if (!$medicine) {
            return response()->json(['error' => 'The information of medicine dosn\'t exist'], 404);
        }*/
        return response()->json([
            'stock' => $stock,
            

        ], 200);
    }
    public function getMedicineBypharmacy($id)
    {
        /*$info = [

            'id_pharmacy' => 'required|exists:pharmacy,id_pharmacy',
        ];
        $validator = Validator::make($request->all(), $info);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }
*/
      
        $stock = Stock::where('pharmacy_id_pharmacy', $id)->
        join('medicine', 'medicine_idmedicien', '=', 'id_medicine')->get();
/*
        if (!$stock) {
            return response()->json(['error' => 'Le pharmacy spécifié n\'existe pas'], 404);
        }
        $medicineId = $stock->medicine_idmedicien;
        $medicine = Medicine::find($medicineId);

        if (!$medicine) {
            return response()->json(['error' => 'Les informations sur le médicament ne sont pas disponibles'], 404);
        }*/
        return response()->json([
            'stock' => $stock,

        ], 200);
    }


    public function getAllMedicines()
    {
        $medicines = Medicine::all();

        return response()->json([
            'medicines' => $medicines,
        ], 200);
    }
    public function addMedicine(Request $request)
    {
        $info = [
            'name_medicine' => 'required|string',
            'bar_code' => 'required|integer',
            'image' => 'nullable|string',
        ];

        $validator = Validator::make($request->all(), $info);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $name = $request->input('name_medicine');
        $barCode = $request->input('bar_code');
        $image = $request->input('image');

        $medicine = new Medicine();
        $medicine->name_medicine = $name;
        $medicine->bar_code = $barCode;
        $medicine->image = $image;
        $medicine->save();

        return response()->json([
            'message' => 'Medicine added successfully',
            'medicine' => $medicine,
        ], 200);
    }
    public function getOrderDetail($id)
    {
        $prescription = Prescription::with('medicines')
        ->where('id_order', $id)
        ->first();

        $doctor = File::select('doctor_account.first_name', 'doctor_account.last_name')
        ->where("id_file", $prescription->file_id_file)
        ->join('doctor', 'file.doctor_id_doctor', '=', 'doctor.id_doctor')
        ->join('account AS doctor_account', 'doctor.account_id_account', '=', 'doctor_account.id_account')
        ->get();

        $patient = File::select('patient_account.first_name', 'patient_account.last_name','patient_account.address','patient_account.phone_number')
        ->where("id_file", $prescription->file_id_file)
        ->join('patient', 'file.patient_id_patient', '=', 'patient.id_patient')
        ->join('account AS patient_account', 'patient.account_id_account', '=', 'patient_account.id_account')
        ->get();

        $medicines = $prescription->medicines->map(function ($medicine) {
            return [
                'name' => $medicine->name_medicine,
                'quantity' => $medicine->pivot->quantity,
                'dose' => $medicine->pivot->dose,
                'price'=> $medicine->price,
            ];
        });

        return response()->json([
            'doctor' => $doctor,
            'patient' => $patient,
            'prescription' => [
                'id_order' => $prescription->id_order,
                'date' => $prescription->date,
                'state' => $prescription->state,
                'file_id_file' => $prescription->file_id_file,
                'medicines' => $medicines,
            ],

        ], 200);
    }
    public function getOrder($id) {
        $prescriptions = Prescription::where('id_pharmacy', $id)
        ->get();

    foreach ($prescriptions as $prescription) {
        $patient = File::select('patient_account.first_name', 'patient_account.last_name')
            ->where("id_file", $prescription->file_id_file)
            ->join('patient', 'file.patient_id_patient', '=', 'patient.id_patient')
            ->join('account AS patient_account', 'patient.account_id_account', '=', 'patient_account.id_account')
            ->first();

        $prescription->patient_name = $patient->first_name . ' ' . $patient->last_name;
    }

    return response()->json([
        'prescriptions' => $prescriptions,
    ], 200);
    }
    public function acceptOrder($id)
    {
        $order = Prescription::find($id);

        if (!$order) {
            return response()->json(['error' => 'order not found'], 404);
        }

        $order->state = 'accepted';
        $order->save();

        return response()->json([
            'message' => 'Order accepted successfully',
            'order' => $order,
        ], 200);
    }

    public function addComplaint(Request $request)
    {
      
        $complaint =  Complaint::create([
            'sender' => $request->input('sender'),
            'resiver' => $request->input('resiver'),
            'subject' => "Your order is refused",
            'content' => $request->input('content'),
            'date' => Carbon::today()->format('Y-m-d'),
        ]);

        return response()->json([
            'message' => 'Complaint sent successfully',
            'file' => $complaint,
        ], 200);
    }
    public function refuseOrder($id)
    {
        $renew = Prescription::findOrFail($id);
        

       $doctor =  File::where("id_file", $renew->file_id_file)
        ->join('doctor', 'file.doctor_id_doctor', '=', 'doctor.id_doctor')
        //->join('account AS doctor_account', 'doctor.account_id_account', '=', 'doctor_account.id_account')
        ->first();

        $pharmacist = Pharmacy::where('id_pharmacy',$renew->id_pharmacy)
        ->join('pharmacist', 'id_pharmacy', '=', 'pharmacy_id_pharmacy')
        //->join('account', 'account_id_account', '=', 'id_account')
        ->first();



       // return response()->json(['message' =>  $doctor,'meddssage' => $pharmacist]);

        Complaint::create([
            'sender' => $pharmacist->account_id_account,
            'resiver' => $doctor->account_id_account,
            'subject' => "Order refused",
            'content' => "Your order have refused connect the admin to repost your order",
            'date' => Carbon::today()->format('Y-m-d'),
        ]);


        $renew->id_pharmacy = null;
    return response()->json(['message' => 'Order deleted successfully']);

    }
    
}
