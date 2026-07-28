using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;

public class PlayerController : MonoBehaviour
{

    [SerializeField] private bool multim_control = false; // Speed for forward/backward movement
    // [SerializeField] private bool gaze_control = false; // Speed for forward/backward movement

    [SerializeField] private float baseSpeed = 15f; // Speed for forward/backward movement
    [SerializeField] private float turnSpeed = 90f; // Degrees per second for turning (yaw)
    [SerializeField] private float movementDamping = 0.1f; // Damping to reduce velocity over time
    [SerializeField] public float listenInterval = 0.5f;          // Time interval in seconds to listen to the keyboard

    [SerializeField] private float current_angular = 0.0f;
    [SerializeField] private float turn_angular = 45.0f;
    [SerializeField] private int my_angle = 1;


    [SerializeField] private bool can_right = true;
    [SerializeField] private bool can_left = true;
    [SerializeField] private bool can_listen = true;

    [SerializeField] private float using_time = 0.0f;
    [SerializeField] private bool running = false;


    private float speedMultiplier = 1f; // Modifier for movement speed
    private Rigidbody rb;
    public GameObject Camera;
    private UdpSocket udps;
    private coin coin;
    private bool pressed = false;
    

    

    private float timeSinceLastCheck = 0f;

    private void Awake()
    {
        // udps = Camera.GetComponent<UdpSocket>();
        udps = GetComponent<UdpSocket>();
        coin = GetComponent<coin>();
        if(udps == null){
            Debug.LogError("UdpSocket component not found on GameObject");
            print("UdpSocket component not found on GameObject");
        }
        Component[] components = GetComponents(typeof(Component));
        foreach(Component component in components) {
            Debug.Log(component.ToString());
        }
        // Get the Rigidbody component
        rb = GetComponent<Rigidbody>();
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
        using_time = 0.0f;
    }

    void FixedUpdate()
    {
        HandleMovement();
        ApplyDamping();
    }

    void Update()
    {
        if (coin.count == 10)
        {
            running = false;
        }
        if(running)
        {
            using_time += Time.deltaTime;
        }
        // Check if the interval has passed
        if(can_listen){
            HandleRotation();
        }
        else
        {
            timeSinceLastCheck += Time.deltaTime;

            if (timeSinceLastCheck >= listenInterval)
            {
                // Reset the timer
                timeSinceLastCheck = 0f;

                // can listen to the keyboard again
                can_listen = true;
            }
        }
    }

    private void HandleMovement()
    {
        Vector3 deltaPosition = Vector3.zero;

        // Forward/backward movement
        // if (keyboard_control){
        //     if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
        //     {
        //         deltaPosition += transform.forward;
                
        //     }
        // } else {
        //     if (udps.swimming)
        //     {
        //         deltaPosition += transform.forward;
        //         udps.swimming = false;
        //         // deltaPosition.Normalize(); // Prevent faster diagonal movement
        //         // rb.AddForce(deltaPosition * baseSpeed * speedMultiplier * 6, ForceMode.Acceleration);
        //     }
        // }
        float m = 1f;
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
        {
            pressed = true;
            deltaPosition += transform.forward;
        }
        // bool n = !keyboard_control;
        if (multim_control && udps.swimming)
        {
            pressed = true;
            // print(udps.swimming);
            // print(keyboard_control);
            deltaPosition += transform.forward;
            udps.swimming = false;
            m = 20f;
        }

        // if (udps.swimming)
        // {
        //     deltaPosition += transform.forward;
        //     udps.swimming = false;
        // }
        if (pressed && coin.count == 0)
        {
            running = true;
            pressed = false;
        }

        // Apply movement using Rigidbody
        deltaPosition.Normalize(); // Prevent faster diagonal movement
        rb.AddForce(deltaPosition * baseSpeed * speedMultiplier * m, ForceMode.Acceleration);
    }

    private void HandleRotation()
    {
        float turnDirection = 0f;
        current_angular = transform.eulerAngles.y;
        // OnTriggerEnter();

        // Left/right rotation based on keyboard input
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
        {
            pressed = true;
            if (true)
            {
                turnDirection = -1f;
                my_angle -= 1;
                can_listen = false;
            }
        }
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
        {
            pressed = true;
            if (true)
            {
                turnDirection = 1f;
                my_angle += 1;
                can_listen = false;
            }
        }
        if (multim_control){
            if (udps.turn == "l")
            {
                pressed = true;
                if (true)
                {
                    turnDirection = -1f;
                    my_angle -= 1;
                    can_listen = false;
                }
            }
            if (udps.turn == "r")
            {
                pressed = true;
                if (true)
                {
                    turnDirection = 1f;
                    my_angle += 1;
                    can_listen = false;
                }
            }
        }
        if (pressed && coin.count == 0)
        {
            running = true;
            pressed = false;
        }

        // Rotate the player around the Y-axis
        // float turnAmount = turnDirection * turnSpeed * Time.deltaTime * turn_angular;
        float turnAmount = turnDirection * turn_angular;
        transform.Rotate(0, turnAmount, 0);
    }

    private void ApplyDamping()
    {
        // Reduce velocity over time to create smoother stopping behavior
        rb.velocity *= (1 - movementDamping);
    }

    private void AdjustSpeed()
    {
        // Adjust movement speed multiplier using mouse scroll wheel
        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (scroll != 0f)
        {
            speedMultiplier = Mathf.Clamp(speedMultiplier + scroll * 0.2f, 0.1f, 10f);
        }
    }

    // private void OnTriggerEnter()
    // {
    //     if (my_angle == 1)
    //     {
    //         can_right = true;
    //         can_left = true;
    //     }
    //     else if (my_angle == 0)
    //     {
    //         can_right = true;
    //         can_left = false;
    //     }
    //     else
    //     {
    //         can_right = false;
    //         can_left = true;
    //     }
    // }

}
