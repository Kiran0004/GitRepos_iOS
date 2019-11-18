# GitRepos_iOS

This project will list the most starred Github repos that were created in the last 30 days. You'll be fetching the sorted JSON data directly from the Github API

This application has following components:

NetworkHelper - Makes network calls with a callback mechanism (completion handler). Only GET is supported as of now.
ImageDownloadHelper - Downloads images and store them in cache

A model class and a cell to consume that model.

App specs:
Base SDK iOS 13.1, Minimum deployment target iOS 13.1
Used XCode 11.1
