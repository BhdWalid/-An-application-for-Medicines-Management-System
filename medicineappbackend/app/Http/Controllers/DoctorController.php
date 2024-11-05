<?php

namespace App\Http\Controllers;


use App\Models\Doctor;
use App\Models\Delivery;
use App\Models\File;
use App\Models\Renew;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\Complaint;
use App\Models\detail;
use App\Models\Medicine;
use App\Models\Account;
use App\Models\Pharmacy;
use App\Models\Prescription;
use App\Models\Stock;
use Illuminate\Support\Facades\Validator;


class DoctorController extends Controller
{

    /*public function inscription(Request $request)
    {
        $utilisateurDonne = $request->validate(
            [
                "first_name" => ["required", "string", "min:2", "max:255"],
                "last_name" => ["required", "string", "min:2", "max:255"],
                "type_user" => ["required", "string", "min:2", "max:255"],
                "email" => ["required", "email", "unique:doctors,email"],
                "password" => ["required", "string", "min:8", "max:30"],
            ]

        );

        $utilisateurs = Doctor::create([
            "first_name" => $utilisateurDonne["first_name"],
            "last_name" => $utilisateurDonne["last_name"],
            "type_user" => $utilisateurDonne["type_user"],
            "email" => $utilisateurDonne["email"],
            "password" => bcrypt($utilisateurDonne["password"]),
        ]);
        return response($utilisateurs, 201);
    }

    public function connexion(Request $request)
    {
        $utilisateurDonne = $request->validate(
            [
                "email" => ["required", "email"],
                "password" => ["required", "string", "min:8", "max:30"],
            ]
        );
        $utilisateur = Doctor::where("email", $utilisateurDonne["email"])->first();
        if (!$utilisateur) return response(["message" => "No user found with the following email $utilisateurDonne[email]"], 401);
        if (!Hash::check($utilisateurDonne["password"], $utilisateur->password)) {
            return response(["message" => "No user found with this password "], 401);
        }
        $token = $utilisateur->createToken("CLE_SECRETE")->plainTextToken;
        return response([
            "utilisateur" => $utilisateur,
            "token" => $token
        ], 200);
    }*/

    public function addFile(Request $request)
    {
      
        $file =  File::create([
            'reason' => $request->input('reason'),
            'doctor_id_doctor' => $request->input('doctor_id_doctor'),
            'patient_id_patient' => $request->input('patient_id_patient'),
        ]);

        return response()->json([
            'message' => 'File added successfully',
            'file' => $file,
        ], 200);
    }

    public function updateFile(Request $request, $id)
    {
        $info = [
            'reason' => 'required|string',
        ];

        $validator = Validator::make($request->all(), $info);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $reason = $request->input('reason');

        $file = File::find($id);

        if (!$file) {
            return response()->json(['error' => 'File not found'], 404);
        }

        $file->reason = $reason;
        $file->save();

        return response()->json([
            'message' => 'File updated successfully',
            'file' => $file,
        ], 200);
    }
    public function deleteFile( $id)
    {
        // Find the file by ID
        $file = File::find($id);

        // Check if the file exists
        if (!$file) {
            return response()->json(['error' => 'File not found'], 400);
        }

        // Delete the file
        $file->delete();

        return response()->json(['message' => 'File deleted successfully'], 200);
    }
    public function getFile($id)
{
    $file = File::where("id_file", $id)
        ->join('patient', 'file.patient_id_patient', '=', 'patient.id_patient')
        ->join('account AS patient_account', 'patient.account_id_account', '=', 'patient_account.id_account')
        ->get();

    $doctor = File::where("id_file", $id)
        ->join('doctor', 'file.doctor_id_doctor', '=', 'doctor.id_doctor')
        ->join('account AS doctor_account', 'doctor.account_id_account', '=', 'doctor_account.id_account')
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
            'doctor' => $doctor,
        ], 200);
    }
    $medicines = $prescription->medicines->map(function ($medicine) {
        return [
            'name' => $medicine->name_medicine,
            'quantity' => $medicine->pivot->quantity,
            'dose' => $medicine->pivot->dose,
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
        'doctor' => $doctor,
    ], 200);
}

    

    public function getDoctorFiles($id)
    {
        // Find the file by ID
        $files = File::where("doctor_id_doctor", $id)
    ->join('patient', 'file.patient_id_patient', '=', 'patient.id_patient')
    ->join('doctor', 'file.doctor_id_doctor', '=', 'doctor.id_doctor')
    
    ->join('account AS doctor_account', 'doctor.account_id_account', '=', 'doctor_account.id_account')
    ->join('account AS patient_account', 'patient.account_id_account', '=', 'patient_account.id_account')
    ->get();

        // Check if the file exists
        if (!$files) {
            return response()->json(['error' => 'File not found'], 404);
        }

        // Return the file data
        return response()->json(['file' => $files], 200);
    }


    public function CreatePrescription(Request $request)
    {
        $info = [
            'id_renew' => 'exists:renew,id_renew',
            'id_file' => 'required|exists:file,id_file',
            'id_pharmacy' => 'required|exists:pharmacy,id_pharmacy',
            'date' => 'required',
            'detail.*.id_medicine' => 'required|integer',
            'detail.*.dose' => 'required|string',
            'detail.*.quantity' => 'required|integer',
            'detail.*.description' => 'required|string',
        ];

        $validator = Validator::make($request->all(), $info);

        // Check if the validation fails
        if ($validator->fails()) {
            // Return the validation errors
            return response()->json(['errors' => $validator->errors()], 400);
        }

        

        $id_file = $request->input('id_file');
        $date = $request->input('date');
        $state = 'pending';
        $id_pharmacy = $request->input('id_pharmacy');

        // Create the prescription
        $prescription = new Prescription();
        $prescription->file_id_file = $id_file;
        $prescription->date = $date;
        $prescription->state = $state;
        $prescription->id_pharmacy = $id_pharmacy;
        // Add other prescription attributes if necessary
        $prescription->save();

        $id_order = $prescription->id_order;
        $medicines = $request->input('detail');

        // Check if the medicines array is null or empty
        if (!$medicines || empty($medicines)) {
            return response()->json(['error' => 'Aucun médicament spécifié dans la demande'], 400);
        }

        // Iterate over the medicines array and create details
        foreach ($medicines as $medicine) {
            $id_medicine = $medicine['id_medicine'];
            $dose = $medicine['dose'];
            $quantity = $medicine['quantity'];
            $description = $medicine['description'];
            // Find the medicine by name
            $medicineObj = Medicine::where('id_medicine', $id_medicine)->first();

            if (!$medicineObj) {
                return response()->json(['error' => 'Le médicament spécifié n\'existe pas'], 404);
            }


            $stock = Stock::where('medicine_idmedicien',$id_medicine)
            ->where('pharmacy_id_pharmacy',$id_pharmacy)
            ->first();

        // Update the stock with the provided data
        $stock->quantity = $stock->quantity - $quantity;
        $stock->save();



            // Create the detail
            $detail = new Detail();
            $detail->medicine_idmedicien = $id_medicine;
            $detail->dose = $dose;
            $detail->quantity = $quantity;
            $detail->description = $description;
            $detail->order_id_order = $id_order;
            $detail->save();

            

        }


        if($request->input('id_renew') != null ){
            $renew = Renew::find($request->input('id_renew'));

        $renew->delete();
        }
        return response()->json([
            'message' => 'Prescription created',
            'detail' => Detail::where('order_id_order', $id_order)->get(),
            'prescription' => $prescription
        ], 200);
    }




    public function passerCommande(Request $request)
    {
        // Valider les données de la requête
        $validatedData = $request->validate([
            'id_product' => 'required|exists:produits,id',
            'quantite' => 'required|integer|min:1',
        ]);



        // Vérifier si le pharmacien accepte la commande (à implémenter selon vos critères)
        $pharmacienAccepte = true; // Exemple : toujours accepté pour l'instant

        if ($pharmacienAccepte) {
            $productId = $validatedData['id_product'];
            $quantity = $validatedData['quantite'];

            // Vérifier si la quantité de produit disponible est suffisante
            $produit = Medicine::findOrFail($productId);

            if ($produit->quantity >= $quantity) {
                // Créer une nouvelle commande
                $commande = new Delivery();
                $commande->id_product = $productId;
                $commande->quantity = $quantity;
                $commande->save();

                // Diminuer la quantité du produit
                $produit->quantity -= $quantity;
                $produit->save();

                return response()->json(['message' => 'Commande passée avec succès']);
            } else {
                return response()->json(['message' => 'Quantité de produit insuffisante'], 400);
            }
        } else {
            return response()->json(['message' => 'Le pharmacien n\'a pas accepté la commande'], 400);
        }
    }
 

    
    public function verifyEmail(Request $request){

    $account = Account::select('id_patient','first_name','last_name')->where('email', $request->input('email'))
                    ->where('type_user', 'patient')
                    ->join('patient', 'account_id_account', '=', 'id_account')
                    ->first();

    if ($account) {
        
        return response()->json([
            'message' => 'Email is available for patient.',
            'account' => $account
        ]);
    } else {
        // Email does not exist or type_user is not 'patient'
        return response()->json(['error' => 'Email is not available for patient.'], 400);
    }
    }
    
    public function chossePharmacy(Request $request) {


        $medicines = $request->json()->all();
    $medicineIds = array_column($medicines, 'id_medicine');
    $medicines = $request->json()->all();
    $pharmacies = [];

    foreach ($medicines as $medicine) {
        $medicineId = $medicine['id_medicine'];
        $quantity = $medicine['quantity'];

        $pharmacyIds = Stock::where('medicine_idmedicien', $medicineId)
            ->where('quantity', '>=', $quantity)
            ->pluck('pharmacy_id_pharmacy')
            ->toArray();

        if (empty($pharmacies)) {
            $pharmacies = $pharmacyIds;
        } else {
            $pharmacies = array_intersect($pharmacies, $pharmacyIds);
        }

        if (empty($pharmacies)) {
            break; // No pharmacies have all the requested medicines
        }
    }
        $pharmaciesWithMedicines = Pharmacy::whereIn('id_pharmacy', $pharmacies)->get();
    
        return response()->json(['pharmacies' =>$pharmaciesWithMedicines],200);
    }
    public function viewRenows($id)
    {
        $renews = Renew::with(['prescription' => function ($query) {
            $query->with('medicines');
        }])
            ->whereHas('prescription', function ($query) use ($id) {
                $query->whereHas('file', function ($query) use ($id) {
                    $query->where('doctor_id_doctor', $id);
                });
            })
            ->get();

            foreach ($renews as $renew) {
                $renew->prescription->first_name = $renew->prescription->file->patient->account->first_name; 
                $renew->prescription->last_name = $renew->prescription->file->patient->account->last_name;
            }

        return response()->json(['renows' => $renews]);
    }

    public function refuseRenew($id)
    {
        $renew = Renew::findOrFail($id);
        $renew->delete();

    return response()->json(['message' => 'Renew deleted successfully']);

    }

}
