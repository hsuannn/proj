using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Vuforia;

public class AdvCamAPI : MonoBehaviour {

    void Start()
    {
        VuforiaARController.Instance.RegisterVuforiaStartedCallback(OnVuforiaStarted);
    }

    void OnVuforiaStarted()
    {
        // Get the fields
        IEnumerable cameraFields = CameraDevice.Instance.GetCameraFields();

        // Print fields to device logs
        foreach (CameraDevice.CameraField field in cameraFields)
        {
            Debug.Log("Key: " + field.Key + "; Type: " + field.Type);
        }

        // Retrieve a specific field and print to logs
        string focusMode = "";

        CameraDevice.Instance.GetField("focus-mode", out focusMode);

        Debug.Log("FocusMode: " + focusMode);
    }

}
