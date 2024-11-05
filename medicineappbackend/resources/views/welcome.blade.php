<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Welcome to Our Website</title>
    <link href="{{asset('vendor/fontawesome-free/css/all.min.css')}}" rel="stylesheet" type="text/css">
    <link href="{{asset('vendor/bootstrap/css/bootstrap.min.css')}}" rel="stylesheet" type="text/css">
    <link href="{{asset('css/ruang-admin.min.css')}}" rel="stylesheet">
</head>

<body>
    <div class="bg">
        <!-- Welcome Content -->
        <div class="container-welcome">
            <div class="row justify-content-center">
                <div class="col-xl-6 col-lg-12 col-md-9">
                    <div class="card shadow-sm my-5">
                        <div class="card-body p-0">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="welcome-form">
                                        <div class="text-center">
                                            <img src="{{asset('images/cover.png')}}" alt="Logo" style="width:1000px;height:300px; margin-left:auto; margin-right:auto;">
                                        </div>
                                        <div class="dash">
                                            <h1 class="h1 text-gray-900 mb-4" style="font-size: 3.5rem; position: absolute; top: 28%; left: 50%; transform: translate(-50%, -50%);">Welcome to Our Website</h1>
                                            <div class="circle circle1">
                                                <div class="text-center">
                                                    <div class="circle-logo">
                                                        <img src="{{ asset('images/login-logo-png-10.png') }}" alt="Logo" class="logo-img" style="width:230px;height:230px; margin-left:auto; margin-right:auto;">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="container">
                                                <div class="decorated-space">
                                                    <div class="info">
                                                        <h2 class="h2 text-gray-900 mb-4" style="font-size: 2.5rem;">Case Description</h2>
                                                        <p>This website is designed to provide users with access to various features and services related to the pharmacy industry. It allows users to:</p>
                                                        <ul>
                                                            <li>Submit account creation requests</li>
                                                            <li>View and manage complaints</li>
                                                            <li>Access pharmacy information and details</li>
                                                            <li>Search for nearby pharmacies</li>
                                                            <li>And much more!</li>
                                                        </ul>
                                                        <p>Feel free to explore the different sections of the website and utilize the functionalities provided. If you have any questions or encounter any issues, please don't hesitate to contact our support team.</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
            <defs>
                <path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
            </defs>
            <g class="parallax">
                <use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7)" />
                <use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
                <use xlink:href="#gentle-wave" x="48" y="5" fill="rgba(255,255,255,0.3)" />
                <use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
            </g>
        </svg>
    </div>
    <!-- this page's style -->
    <style>
        @import url(//fonts.googleapis.com/css?family=Lato:300:400);

        .container-welcome {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        h1,
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .info {
            margin-bottom: 10px;
        }

        .info span {
            font-weight: bold;
        }

        .decorated-space {
            background-color: #fff;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .circle {
            position: relative;
            /* Change position to relative */
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background-color: white;
            display: flex;
            /* Add display flex */
            justify-content: center;
            /* Add justify-content center */
            align-items: center;
            /* Add align-items center */
        }

        .h1 {
            top: -100px;
            left: 100px;
        }

        .circle1 {
            top: -200px;
            left: -350px;
        }

        .circle-logo {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            height: 100%;
        }

        .logo-img {
            width: 100px;
            height: 100px;
        }

        .welcome-form {
            text-align: center;
        }

        .bg {
            position: relative;
            background: linear-gradient(60deg, rgba(84, 58, 183, 1) 0%, rgba(0, 172, 193, 1) 100%);
        }

        .waves {
            position: relative;
            width: 100%;
            height: 15vh;
            margin-bottom: -7px;
            /*Fix for safari gap*/
            min-height: 100px;
            max-height: 150px;
        }

        /* Animation */

        .parallax>use {
            animation: move-forever 25s cubic-bezier(.55, .5, .45, .5) infinite;
        }

        .parallax>use:nth-child(1) {
            animation-delay: -2s;
            animation-duration: 7s;
        }

        .parallax>use:nth-child(2) {
            animation-delay: -3s;
            animation-duration: 10s;
        }

        .parallax>use:nth-child(3) {
            animation-delay: -4s;
            animation-duration: 13s;
        }

        .parallax>use:nth-child(4) {
            animation-delay: -5s;
            animation-duration: 20s;
        }

        @keyframes move-forever {
            0% {
                transform: translate3d(-90px, 0, 0);
            }

            100% {
                transform: translate3d(85px, 0, 0);
            }
        }

        /*Shrinking for mobile*/
        @media (max-width: 768px) {
            .waves {
                height: 40px;
                min-height: 40px;
            }

            .content {
                height: 30vh;
            }

            h1,
            h2 {
                font-size: 30px;
            }
        }
    </style>
    <!-- Welcome Content -->
    <script src="{{asset('vendor/jquery/jquery.min.js')}}"></script>
    <script src="{{asset('vendor/bootstrap/js/bootstrap.bundle.min.js')}}"></script>
    <script src="{{asset('vendor/jquery-easing/jquery.easing.min.js')}}"></script>
    <script src="{{asset('js/ruang-admin.min.js')}}"></script>


</body>

</html>