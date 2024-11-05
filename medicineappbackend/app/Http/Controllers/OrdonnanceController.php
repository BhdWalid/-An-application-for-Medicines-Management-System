<?php

namespace App\Http\Controllers;

use App\Models\detail;
use App\Models\Prescription;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class OrdonnanceController extends Controller
{


    public function createPrescription(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'id_product' => 'required|integer',
                'quantite' => 'required|integer',
                'dosage' => 'required|string',
            ]);

            $product = Product::findOrFail($validatedData['id_product']);

            DB::beginTransaction();

            $prescription = new Prescription();
            $prescription->id_product = $product->id;
            $prescription->name_product = $product->name;
            $prescription->quantite = $validatedData['quantite'];
            $prescription->dosage = $validatedData['dosage'];
            $prescription->product()->associate($product);
            $prescription->save();

            $order = new detail();
            $order->quantite = $validatedData['quantite'];
            $order->dosage = $validatedData['dosage'];
            $order->product()->associate($product);
            $order->prescription()->associate($prescription);
            $order->save();

            DB::commit();

            return response()->json(['message' => 'Prescription created successfully']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Failed to create prescription'], 500);
        }
    }


    public function crPrescription(Request $request)
    {
        $validatedData = $request->validate([
            'id_product' => 'required|integer',
            'quantite' => 'required|integer',
            'dosage' => 'required|string',
        ]);

        $product = Product::findOrFail($validatedData['id_product']);

        $prescription = new Prescription();
        $prescription->name_product = $product->name;
        $prescription->quantite = $validatedData['quantite'];
        $prescription->dosage = $validatedData['dosage'];
        $prescription->save();

        $order = new detail();
        $order->prescription_id = $prescription->id;
        $order->product_id = $product->id;
        $order->quantite = $validatedData['quantite'];
        $order->dosage = $validatedData['dosage'];
        $order->save();

        return response()->json(['message' => 'Prescription created successfully']);
    }




    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'id_product' => 'required|integer',
                'quantite' => 'required|integer',
                'dosage' => 'required|string',
            ]);

            $product = Product::findOrFail($validatedData['id_product']);

            DB::beginTransaction();

            // Créer une nouvelle entrée dans la table Prescription
            $prescription = Prescription::create([
                'id_product' => $validatedData['id_product'],

                'quantite' => $validatedData['quantite'],
                'dosage' => $validatedData['dosage'],
                // Ajouter les autres colonnes de la table Prescription
            ]);

            // Ajouter les informations de dosage pour le produit correspondant
            $produit = Product::where('id_product', $validatedData['id_product'])->first();
            $dosage = detail::create([
                'id_prescription' => $prescription->id,
                'id_produit' => $produit->id,
                'quantite' => $validatedData['quantite'],
                'dosage' => $validatedData['dosage'],
            ]);

            // Afficher une page de confirmation
            return response()->json(['message' => 'Prescription created successfully']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Failed to create prescription'], 500);
        }
    }
    public function createPre(Request $request)
    {
        // Supposons que vous avez déjà importé les modèles nécessaires (Prescription, Product, PrescriptionProduct)
        $file = $request->input('id_file');
        // 1. Récupérez les détails de la prescription à partir de la table "files"
        $patientId = $file->patient_id;
        $doctorId = $file->doctor_id;

        // 2. Insérez les informations de la prescription dans la table "prescriptions"
        $prescription = new Prescription;
        $prescription->patient_id = $patientId;
        $prescription->doctor_id = $doctorId;
        // Ajoutez d'autres attributs de la prescription si nécessaire
        $prescription->save();

        // Récupérez l'ID de la prescription nouvellement créée
        $prescriptionId = $prescription->id;

        // 3. Récupérez les détails des produits de la prescription
        $products = [
            ['id' => 1, 'quantity' => 2, 'dosage' => '10mg'],
            ['id' => 2, 'quantity' => 3, 'dosage' => '20mg'],
            // Ajoutez d'autres produits si nécessaire
        ];

        // 4. Vérifiez si la quantité demandée du produit est disponible dans la table "products"
        foreach ($products as $product) {
            $productId = $product['id'];
            $quantity = $product['quantity'];

            $availableQuantity = Product::find($productId)->quantity;

            if ($availableQuantity < $quantity) {
                // Gérez le cas où la quantité disponible est insuffisante
                // Affichez un message d'erreur ou prenez une autre mesure appropriée
            }
        }

        // 5. Mettez à jour la quantité des produits dans la table "products"
        foreach ($products as $product) {
            $productId = $product['id'];
            $quantity = $product['quantity'];

            $product = Product::find($productId);
            $product->quantity -= $quantity;
            $product->save();
        }

        // 6. Insérez les détails des produits dans la table associative
        foreach ($products as $product) {
            $productId = $product['id'];
            $quantity = $product['quantity'];
            $dosage = $product['dosage'];

            $prescriptionProduct = new detail();
            $prescriptionProduct->prescription_id = $prescriptionId;
            $prescriptionProduct->product_id = $productId;
            $prescriptionProduct->quantity = $quantity;
            $prescriptionProduct->dosage = $dosage;
            $prescriptionProduct->save();
        }

        // La prescription avec les produits associés a été créée avec succès.

    }



    public function create(Request $request)
    {
        $info = [
            'quantity' => 'nullable|integer',
            'price' => 'nullable|integer',
            'date_f' => 'nullable|date',
            'date_e' => 'nullable|date',
        ];
        $validator = Validator::make($request->all(), $info);

        // Check if the validation fails
        if ($validator->fails()) {
            // Return the validation errors
            return response()->json(['errors' => $validator->errors()], 400);
        }
        // Supposons que vous recevez les détails de la prescription et des produits via une requête HTTP

        // Récupérez les détails de la prescription
        $patientId = $request->input('patient_id');
        $doctorId = $request->input('doctor_id');
        // Ajoutez d'autres détails de la prescription si nécessaire

        // Insérez les informations de la prescription dans la table "prescriptions"
        $prescription = new Prescription;
        $prescription->patient_id = $patientId;
        $prescription->doctor_id = $doctorId;
        // Ajoutez d'autres attributs de la prescription si nécessaire
        $prescription->save();

        // Récupérez l'ID de la prescription nouvellement créée
        $prescriptionId = $prescription->id;

        // Récupérez les détails des produits de la prescription depuis la requête
        $products = $request->input('products');

        // Parcourez chaque produit et insérez-le dans la table associative
        foreach ($products as $product) {
            $productId = $product['id'];
            $quantity = $product['quantity'];
            $dosage = $product['dosage'];

            // Vérifiez si la quantité disponible est suffisante dans la table "products"
            $availableQuantity = Product::find($productId)->quantity;

            if ($availableQuantity < $quantity) {
                // Gérez le cas où la quantité disponible est insuffisante
                return response()->json(['message' => 'Quantité de produit insuffisante.'], 400);
            }

            // Insérez les détails du produit dans la table associative
            $prescriptionProduct = new detail;
            $prescriptionProduct->prescription_id = $prescriptionId;
            $prescriptionProduct->product_id = $productId;
            $prescriptionProduct->quantity = $quantity;
            $prescriptionProduct->dosage = $dosage;
            $prescriptionProduct->save();

            // Mettez à jour la quantité dans la table "products" en soustrayant la quantité demandée
            $product = Product::find($productId);
            $product->quantity -= $quantity;
            $product->save();
        }

        // Retournez une réponse JSON pour indiquer que la prescription a été créée avec succès
        return response()->json(['message' => 'Prescription créée avec succès.']);
    }
    public function crePrescription(Request $request)
    {
        $medicationList = $request->input("medicine", []);
        $fileId = $request->input("id_file");

        $prescription = Prescription::create([
            'date' => Carbon::today(),
            'id_file' => $fileId,
        ]);

        foreach ($medicationList as $medication) {
            $medicationName = $medication['name_medicine'];
            $repetition = $medication['dosage'];
            $quantityMed = $medication['quantite'];

            // Get the medicine instance by name
            $medicine = Product::where('name_medicine', $medicationName)->first();

            if (!$medicine) {
                // Medicine doesn't exist, create a new one
                $medicine = Product::create([
                    'name_medicine' => $medicationName,
                ]);
            }

            detail::create([
                'dosage' => $repetition,
                'quantite' => $quantityMed,
                'order_id_order' => $prescription->id,
                'medicine_idmedicien' => $medicine->id,
            ]);
        }

        $response = ["message" => "Prescription created successfully"];
        return response()->json($response);
    }
    public function creee(Request $request)
    {
        $info = [
            'id_file' => 'required|exists:file,id_file',
            'date' => 'required|date',
            'state' => 'required|string',

            'medicine.*.id_medicine' => 'required|integer',
            'detail.*.dose' => 'required|string',
            'detail.*.quantity' => 'required|integer',
            'detail.*.description' => 'required|integer',
        ];

        $validator = Validator::make($request->all(), $info);

        // Check if the validation fails
        if ($validator->fails()) {
            // Return the validation errors
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $id_file = $request->input('id_file');
        $date = $request->input('date');
        $state = $request->input('state');
        $id_order = $request->input('id_order');

        // Create the prescription
        $prescription = new Prescription();
        $prescription->id_order = $id_order;
        $prescription->file_id_file = $id_file;
        $prescription->date = $date;
        $prescription->state = $state;
        // Add other prescription attributes if necessary
        $prescription->save();

        $medicines = $request->input('medicine');

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
            $medicineObj = Product::where('id_medicine', $id_medicine)->first();

            if (!$medicineObj) {
                return response()->json(['error' => 'Le médicament spécifié n\'existe pas'], 404);
            }
            // Create the detail
            $detail = new Detail();
            $detail->medicine_idmedicien = $id_medicine;
            $detail->dose = $dose;
            $detail->quantity = $quantity;
            $detail->description = $description;
            $detail->order_id_order = $id_order;
            $detail->save();
        }

        return response()->json([
            'message' => 'Prescription created',
            'detail' => Detail::where('order_id_order', $id_order)->get(),
            'prescription' => $prescription
        ], 200);
    }

    public function cree(Request $request)
    {
        $info = [
            'date' => 'required|date',
            'state' => 'required|string',
            'medicine.*.id_medicine' => 'required|integer',
            'detail.*.dose' => 'required|string',
            'detail.*.quantity' => 'required|integer',
            'detail.*.description' => 'required|string',
            'id_order' => 'required|exists:prescription,id_order',
            'id_file' => 'required|exists:file,id_file',
        ];
        $validator = Validator::make($request->all(), $info);

        // Check if the validation fails
        if ($validator->fails()) {
            // Return the validation errors
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $id_file = $request->input('id_file');
        $date = $request->input('date');
        $state = $request->input('state');
        $id_order = $request->input('id_order');

        // Création de la prescription
        $prescription = new Prescription();
        $prescription->file_id_file = $id_file;
        $prescription->date = $date;
        $prescription->state = $state;
        // Ajoutez d'autres attributs de la prescription si nécessaire
        $prescription->save();
        $medicines = $request->input('medecine');

        // Vérifie si la variable $medicines est null
        if ($medicines === null) {
            return response()->json(['error' => 'Aucun médicament spécifié dans la demande'], 400);
        }

        // Vérification de la disponibilité de la quantité de produit pour chaque produit dans la demande

        foreach ($medicines as $medicine) {
            $medicineId = $medicine = $request->input('id_medicine');
            $quantity = $medicine = $request->input('quantity');
            $dose = $medicine = $request->input('dose');
            $description = $medicine = $request->input('description');

            $medicine = Product::find($medicineId);
            if (!$medicine) {
                return response()->json(['error' => 'Le médicament spécifié n\'existe pas'], 404);
            }



            // Création des détails
            $detail = new Detail();
            $detail->medicine_idmedicien = $medicineId;
            $detail->dose = $dose;
            $detail->description = $description;
            $detail->quantity = $quantity;
            $detail->order_id_order = $id_order;
            $detail->save();
        }
        return response()->json([
            'message' => 'Prescription created',
            'detail' => Detail::where('order_id_order', $id_order)->get(),
            'prescription' => $prescription
        ], 200);
    }
}
