<?php

class PhyreApi {

    public $endpoint;
    public $username;
    public $password;

    public function __construct($endpoint)
    {
//        if (strpos($endpoint, 'http') === false) {
//            $endpoint = 'https://' . $endpoint;
//        }

        $this->endpoint = $endpoint;
    }

    public function setCredentials($username, $password)
    {
        $this->username = $username;
        $this->password = $password;
    }

    public function request($resource = 'health', $params =[], $type = 'GET')
    {
        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $this->endpoint . ':8443/api/' .$resource);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

        if ($type == 'POST') {
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($params));
        } elseif ($type == 'DELETE') {
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
        } elseif ($type == 'PUT') {
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($params));
        }

        $headers = array();
        $headers[] = 'Accept: application/json';
        $headers[] = 'Content-Type: application/json';

        $headers[] = 'X-Api-Key: ' . $this->username;
        $headers[] = 'X-Api-Secret: ' . $this->password;

        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

        $result = curl_exec($ch);

        if (curl_errno($ch)) {
            echo 'Error:' . curl_error($ch);
        }

        curl_close($ch);

        return json_decode($result, true);
    }

}
